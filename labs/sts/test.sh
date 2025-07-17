URL1=http://43.200.22.47
URL2=http://3.34.63.95
curl -X POST -d "hello1" $URL
curl -X POST -d "hello2" $URL
curl -X POST -d "hello3" $URL
curl -X POST -d "hello4" $URL
curl -X POST -d "hello5" $URL
curl -X POST -d "hello6" $URL
curl -X POST -d "hello7" $URL
curl -X POST -d "hello8" $URL
curl -X POST -d "hello9" $URL


# kubectl run test-dns --image=busybox:1.28
# 명령어로 임시 pod 생성해서 출력마다 다른 node에 저장됨을 확인
# 임시 pod 생성은 test에서만 사용 (기록이 안남아서)