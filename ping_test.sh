#!/bin/bash
read -p "Enter address: " host
fails=0

for i in {1..20}; do
  r=$(ping -n 1 $host 2>&1)

  
  if ! echo "$r" | grep -qiE "Antwort|Zeit"; then
    ((fails++))
    echo "[$i] Fail ($fails/3)"
    if [ "$fails" -ge 3 ]; then
      echo "3 consecutive pings failed"
      fails=0
    fi
  else
    fails=0
   
    t=$(echo "$r" | grep -ao "Zeit=[0-9]*" | cut -d'=' -f2)
    
    if [ -n "$t" ] && [ "$t" -gt 100 ] 2>/dev/null; then
      echo "[$i] Too slow: ${t}ms"
    else
      echo "[$i] OK: ${t:-0}ms"
    fi
  fi
  sleep 1
done
echo "Test complete.
