function gserver
  set PORT 3000
  set ADDRESS 127.0.0.1
  set PUBLIC_PATH $HOME/public_html/brain
  
  nohup python -m http.server $PORT -b $ADDRESS -d $PUBLIC_PATH >/dev/null 2>&1 &
end
