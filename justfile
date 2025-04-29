default:
  @just --list

update:
  nix flake update

run-full:
  nix run '#full'

alias test := run-full
alias run := run-lite

run-lite:
  nix run '#lite'
