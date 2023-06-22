if [[ "$1" == "j" ]]; then port=1111; res="hello"
elif [[ "$1" == "n" ]]; then port=1112; res="hello"
elif [[ "$1" == "m" ]]; then port=1113; res="outgoing-http-call"
else echo "usage: $0 j|n|m"; exit 1; fi

echo "curl -X GET http://localhost:${port}/$res"
curl -X GET http://localhost:${port}/$res
