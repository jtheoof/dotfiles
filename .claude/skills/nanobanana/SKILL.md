---
name: nanobanana
description: Generate a new image, or edit/restyle an existing image file, with Nano Banana (Gemini image model via OpenRouter). Use when the user asks to create an image, or to transform an image on disk, e.g. "make photo.png a watercolor".
---

# Nano Banana image generation

Run the `nanobanana` script (in `~/.local/bin`). It calls OpenRouter directly, so it works regardless of the model you are running on.

```bash
nanobanana "<prompt>" <output-path> [input-image...]
```

- With no input image, it generates a new image from the prompt.
- With one or more input images, it edits or restyles them following the prompt.
- It prints the output path on success and exits non-zero with the API error otherwise.

## Rules

- Never overwrite an existing file or the input image: choose a new output name (e.g. `photo-watercolor.png`) unless the user names one.
- Write the output next to the input image, or in the current directory when generating from scratch.
- `OPENROUTER_API_KEY` must be set in the environment. If it is missing, tell the user. Do not look for the key in dotfiles or env files.
- After generating, report the output path and the cost line the script prints to stderr. Do not try to open or display the image unless asked.

## Options

Set these as environment variables on the command:

| Variable | Meaning |
|---|---|
| `NANOBANANA_SIZE` | Output resolution: `1K` (default), `2K` or `4K`. A 4K image costs about $0.24 and returns roughly 6000px on the long side, so ask before using it. |
| `NANOBANANA_ASPECT` | Output aspect ratio, e.g. `16:9`, `9:16`, `21:9`. |
| `NANOBANANA_MAX_INPUT` | Downscale inputs to this many pixels on the long side (default `2048`). Use `0` to send them untouched, e.g. when the input is a canvas the model must preserve. |
| `NANOBANANA_MODEL` or `-m` | Model. The default is `google/gemini-3-pro-image-preview` (Nano Banana Pro). |

## Gotchas

- Use the `-preview` model slug for 4K: plain `google/gemini-3-pro-image` is rejected for 4K. `google/gemini-2.5-flash-image` has no size option and always returns about 1 megapixel.
- Output dimensions come from the model, not from the input. Resize or crop to the target size afterwards (ImageMagick `magick` is available).
- To extend an image sideways, the model ignores "continue this image" prompts. Paste the edge strip onto a flat grey canvas of the target aspect ratio, ask it to paint only the grey area, and crop next to the seam.
- Report the cost for each call, and say so if a call fails.
