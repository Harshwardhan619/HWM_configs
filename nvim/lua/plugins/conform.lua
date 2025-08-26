return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      python = { "autopep8" },
    },
    formatters = {
      autopep8 = {
        -- Use system-installed autopep8
        command = "autopep8",
        args = { "--aggressive", "--aggressive", "-" },
        stdin = true,
      },
    },
  },
}
