echo ''
echo 'Cleaning up'
killall -9 java
sleep 5
killall -9 node
sleep 5
rm nohup.out

echo 'Starting up wiremock, we dont need no php'
nohup java -jar wiremock/wiremock-1.58-standalone.jar &
sleep 10
echo ''
