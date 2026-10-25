import { Plugin, usePlugin } from "@opencode/plugin/tui"
import { execFile } from "node:child_process"
import { createSignal, onCleanup, Show } from "solid-js"

const nord = {
  dim: "#4C566A",
  label: "#D8DEE9",
  dir: "#8FBCBB",
  model: "#88C0D0",
  red: "#BF616A",
  orange: "#D08770",
  yellow: "#EBCB8B",
  green: "#A3BE8C",
  purple: "#B48EAD",
}

const tokens = (n: number) => {
  if (n >= 1_000_000) return `${+(n / 1_000_000).toFixed(1)}m`
  if (n >= 1000) return `${Math.round(n / 1000)}k`
  return `${n}`
}

const usageColor = (pct: number) =>
  pct >= 90 ? nord.red : pct >= 70 ? nord.orange : pct >= 50 ? nord.yellow : nord.green

const effortColor = (level: string) =>
  ({ low: nord.dim, medium: nord.orange, med: nord.orange, high: nord.green, xhigh: nord.purple, max: nord.red })[level] ??
  nord.green

const git = (cwd: string, args: string[]) =>
  new Promise<string>((resolve) =>
    execFile("git", ["-C", cwd, ...args], { timeout: 3000 }, (err, stdout) => resolve(err ? "" : stdout.trim())),
  )

let balance: { left: number; usedPct: number; at: number } | undefined
let fetching = false
const refreshBalance = async () => {
  const key = process.env.OPENROUTER_API_KEY
  if (!key || fetching || (balance && Date.now() - balance.at < 60_000)) return
  fetching = true
  try {
    const res = await fetch("https://openrouter.ai/api/v1/credits", {
      headers: { Authorization: `Bearer ${key}` },
      signal: AbortSignal.timeout(5000),
    })
    const { data } = (await res.json()) as { data?: { total_credits: number; total_usage: number } }
    if (data)
      balance = {
        left: data.total_credits - data.total_usage,
        usedPct: data.total_credits > 0 ? Math.floor((data.total_usage * 100) / data.total_credits) : 100,
        at: Date.now(),
      }
  } catch {}
  fetching = false
}

function StatusLine(props: { sessionID?: string }) {
  const context = usePlugin()
  const sessionID = () => {
    const route = context.ui.router.current() as { type?: string; sessionID?: string } | undefined
    return props.sessionID ?? (route?.type === "session" ? route.sessionID : undefined)
  }
  const location = context.location ?? context.data.location.default()
  const directory = location?.directory ?? ""

  const [gitInfo, setGitInfo] = createSignal({ branch: "", added: 0, deleted: 0 })
  const [bal, setBal] = createSignal(balance)

  const refresh = async () => {
    if (directory) {
      const branch = await git(directory, ["rev-parse", "--abbrev-ref", "HEAD"])
      const numstat = branch ? await git(directory, ["diff", "--numstat"]) : ""
      let added = 0
      let deleted = 0
      for (const line of numstat.split("\n")) {
        const [a, d] = line.split("\t")
        added += Number(a) || 0
        deleted += Number(d) || 0
      }
      setGitInfo({ branch, added, deleted })
    }
    await refreshBalance()
    setBal(balance)
  }
  void refresh()
  const timer = setInterval(() => void refresh(), 15_000)
  onCleanup(() => clearInterval(timer))

  const selected = (): { id: string; providerID: string; variant?: string } | undefined => {
    const current = context.ui.model.current() as { modelID?: string; id?: string; providerID: string; variant?: string } | undefined
    if (current) return { id: (current.modelID ?? current.id)!, providerID: current.providerID, variant: current.variant }
    const id = sessionID()
    if (!id) return undefined
    const fromSession = context.data.session.get(id)?.model
    if (fromSession) return fromSession
    const messages = (context.data.session.message.list(id) ?? []) as Array<{ type: string; model?: { id: string; providerID: string; variant?: string } }>
    for (let i = messages.length - 1; i >= 0; i--) if (messages[i].type === "assistant" && messages[i].model) return messages[i].model
    return undefined
  }
  const modelInfo = () => {
    const ref = selected()
    if (!ref) return undefined
    return (context.data.location.model.list(location) ?? []).find(
      (m) => m.modelID === ref.id && m.providerID === ref.providerID,
    )
  }

  const used = () => {
    if (!sessionID()) return 0
    const messages = context.data.session.message.list(sessionID()) ?? []
    for (let i = messages.length - 1; i >= 0; i--) {
      const m = messages[i] as { type: string; tokens?: { input: number; cache: { read: number; write: number } } }
      if (m.type === "assistant" && m.tokens) return m.tokens.input + m.tokens.cache.read + m.tokens.cache.write
    }
    return 0
  }
  const size = () => modelInfo()?.limit.context ?? 200000
  const pct = () => Math.floor((used() * 100) / size())
  const effort = () => selected()?.variant ?? "medium"
  const cost = () => (sessionID() ? context.data.session.cost(sessionID()) : undefined)

  const [frame, setFrame] = createSignal(0)
  const spin = setInterval(() => setFrame((f) => (f + 1) % 14), 100)
  onCleanup(() => clearInterval(spin))
  const busy = () => {
    const id = sessionID()
    if (!id) return false
    const status = context.data.session.status(id) as unknown
    const kind = typeof status === "string" ? status : (status as { type?: string } | undefined)?.type
    return kind === "running" || kind === "busy"
  }
  const bar = () => {
    const pos = frame() < 8 ? frame() : 14 - frame()
    return Array.from({ length: 8 }, (_, i) => (i === pos ? "■" : "⬝")).join("")
  }

  const Sep = () => <span style={{ fg: nord.dim }}>{" | "}</span>

  return (
    <box paddingLeft={2} paddingRight={2} flexShrink={0}>
      <text>
        <Show when={busy()}>
          <span style={{ fg: nord.model }}>{bar()}</span>
          <span style={{ fg: nord.label }}>{" esc"}</span>
          <span style={{ fg: nord.dim }}>{" interrupt"}</span>
          <Sep />
        </Show>
        <Show when={directory}>
          <span style={{ fg: nord.dir }}>{directory.split("/").filter(Boolean).pop() ?? "/"}</span>
          <Show when={gitInfo().branch}>
            <span style={{ fg: nord.dim }}>@</span>
            <span style={{ fg: nord.green }}>{gitInfo().branch}</span>
            <Show when={gitInfo().added + gitInfo().deleted > 0}>
              <span style={{ fg: nord.dim }}>{" ("}</span>
              <span style={{ fg: nord.green }}>{`+${gitInfo().added}`}</span>
              <span style={{ fg: nord.red }}>{` -${gitInfo().deleted}`}</span>
              <span style={{ fg: nord.dim }}>{")"}</span>
            </Show>
          </Show>
        </Show>
        <Show when={directory}>
          <Sep />
        </Show>
        <span style={{ fg: nord.orange }}>{`${tokens(used())}/${tokens(size())}`}</span>
        <span style={{ fg: nord.dim }}>{" ("}</span>
        <span style={{ fg: usageColor(pct()) }}>{`${pct()}%`}</span>
        <span style={{ fg: nord.dim }}>{")"}</span>
        <Sep />
        <span style={{ fg: nord.label }}>{"effort: "}</span>
        <span style={{ fg: effortColor(effort()) }}>{effort()}</span>
        <Show when={cost() !== undefined}>
          <Sep />
          <span style={{ fg: nord.label }}>{`$${(cost() ?? 0).toFixed(2)}`}</span>
          <span style={{ fg: nord.dim }}>{" session"}</span>
        </Show>
        <Show when={bal()}>
          <Sep />
          <span style={{ fg: usageColor(bal()!.usedPct) }}>{`$${bal()!.left.toFixed(2)}`}</span>
          <span style={{ fg: nord.dim }}>{" left"}</span>
        </Show>
        <Sep />
        <span style={{ fg: nord.dim }}>{`v${context.app.version}`}</span>
        <Sep />
        <span style={{ fg: nord.label }}>{"ctrl+p"}</span>
        <span style={{ fg: nord.dim }}>{" commands"}</span>
      </text>
    </box>
  )
}

export default Plugin.define({
  id: "jattali.statusline",
  setup(context) {
    const stopStatus = context.ui.slot({
      append: "app",
      render: (slot: { sessionID?: string }) => <StatusLine sessionID={slot?.sessionID} />,
    })
    const stopFooter = context.ui.slot({
      replace: "prompt.footer",
      render: () => null,
    })
    return () => {
      stopStatus()
      stopFooter()
    }
  },
})
