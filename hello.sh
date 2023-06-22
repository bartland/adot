if [[ "$1" == "j" ]]; then port=1111; res="hello"
elif [[ "$1" == "n" ]]; then port=1112; res="hello"
elif [[ "$1" == "ms" ]]; then port=8080; res="aws-sdk-call"
elif [[ "$1" == "mh" ]]; then port=8080; res="outgoing-http-call"
else echo "usage: $0 j|n|ms|mh"; exit 1; fi

echo "curl -X GET http://localhost:${port}/$res"
curl -X GET http://localhost:${port}/$res
