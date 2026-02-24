# Mac Pro 6,1: Apple EFI requires cold boot (poweroff) for GPU initialization
# Warm reboot leaves GPU in uninitialized state — black screen
alias reboot='echo "Mac Pro 6,1 requires cold boot for GPU init. Use: sudo poweroff"; sudo poweroff'
