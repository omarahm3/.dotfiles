# function to base64 decode a string
function bd --description 'bd <text>'
  echo "$argv[1]" | base64 -d
end
