return {
  "stevearc/conform.nvim",
  opts = {
    format_on_save = false,
    formatters_by_ft = {
      python = { "autopep8" },
      lua = { "stylua" },
    },
    formatters = {
      autopep8 = {
        -- Use system-installed autopep8
        command = "autopep8",
        args = { "--aggressive", "--aggressive", "-" },
        stdin = true,
      },
      stylua = {
        -- Use system binary with absolute path to avoid Mason's version
        command = "/wrk/xhdaatv2_bkup/harshwar/code/ricing/programs/.cargo/bin/stylua",
      },
    },
  },
}
