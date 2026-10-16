-- GitLab handler for fugitive's :GBrowse (and :GBrowse!).
-- Registers Ubisoft's self-hosted GitLab instances so GBrowse can turn the
-- current file/line into an official GitLab URL.
return {
  "shumphrey/fugitive-gitlab.vim",
  dependencies = { "tpope/vim-fugitive" },
  init = function()
    vim.g.fugitive_gitlab_domains = {
      "https://gitlab-ncsa.ubisoft.org", -- NCSA
      "https://gitlab.ubiservices.ubi.com", -- Ubiservices
    }
  end,
}
