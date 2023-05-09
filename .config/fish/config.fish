# A workaround for Fish re-reading config for non-interactive execution:
# https://git.io/yj4KoA
if not status --is-interactive
  exit
end
