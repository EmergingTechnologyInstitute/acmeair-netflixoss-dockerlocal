Acmeair-netflix-docker
======================
この説明はUbuntu trustyとboot2docker上で動くDocker 1.0.0前提にしています。

## 構成

![topology](images/topology.png)

## 設定
### Dockerデーモンのremote API用TCP接続を有効にする
Dockerデーモンの起動用の設定 (`/etc/default/docker`) を以下のように変更します。boot2dockerではデフォルトで有効になっています。

```bash
# Use DOCKER_OPTS to modify the daemon startup options.
#DOCKER_OPTS="-dns 8.8.8.8 -dns 8.8.4.4"
DOCKER_OPTS="-H tcp://0.0.0.0:2375 -H unix://var/run/docker.sock"
```

### Dockerクライアントのコマンド
`docker`コマンドを実行するのに`sudo`が必要な場合は`bin/env.sh`の`docker_cmd`の値を変更します。

```bash
docker_cmd="sudo docker"
```

### Dockerデーモンが使うブリッジの名前
Dockerデーモンが`docker0`とは異なるブリッジを使う場合は`bin/env.sh`の`bridge_name`の値を変更します。

```bash
bridge_name=bridge0
```

## イメージのビルド
イメージをビルドしそれを使う前にライセンスに同意する必要があります。

```bash
cd bin
./acceptlicenses.sh
./buildimages.sh
```

SSHの鍵ペアはイメージのビルド中に生成されます。それは`bin/id_rsa`と`bin/id_rsa.pub`です。秘密鍵はインスタンスにSSHでログインするときに使います。別の鍵ペアを使いたい場合はそれを`bin`ディレクトリに`id_rsa`と`id_rsa.pub`というファイル名にして配置してください。

## 最小構成のコンテナの起動
`startminimum.sh`スクリプトは最小構成のコンテナを起動します。このスクリプトはSkyDNS、SkyDock、1つのCassandra (cassandra1)、データ・ローダ、Eurekaサーバ (サービス・レジストリ)、Zuul (ロードバランサ)、MicroscalerとMicroscalerエージェントを起動します。オート・スケーリング・グループ (ASG) が2つ作成されます。そのうち1つは認証サービス用、もう1つはWebアプリケーション用です。それぞれのASGは期待サイズとしてインスタンスを1つ持つよう設定されます。Microscalerはauth-serviceとwebappを1つづつ起動します。リクエストを処理できるようになるまでスクリプトが終了してから数分待ってください。

```bash
cd bin
./startminimum.sh
```

## APサーバの切り替え
auth-serviceとwebappのデフォルトのAPサーバはIBM WebSphere Application Server Liberty profile (WLP) です。WLPの代わりにTomcatを使うこともできます。`bin/env.sh`の`appserver`の値を変更してください。

```bash
# "wlp" for WAS Liberty profile or "tc" for Tomcat
appserver=tc
```

Tomcat上でauth-serviceとwebappを動かすにはASG (と起動設定) を削除してから再作成してください。

```bash
cd bin
./deleteasg.sh
./configureasg.sh
./startasg.sh
```

## コンテナの追加
autu-serviceとwebappはMicroscalerによって管理されています。それらを追加したい場合はASGの設定を変更してください。

### Cassandra

```bash
./addcassandra.sh
```

## すべてのコンテナの停止

```bash
./stopall.sh
```

## コンテナのIPアドレスの表示

```bash
./showipaddrs.sh
```

## コンテナへのログイン
SSHを使います。SkyDNSとSkyDockを除く全てのコンテナでSSHのサーバが動いています。

```bash
ssh -i bin/id_rsa root@172.17.0.5
```

## 簡易テスト
### Zuulとwebapp

```bash
./testwebapp.sh
```

または

```bash
./testwebapp.sh 172.17.0.6
```

### auth-service

```bash
./testauth.sh
```

または

```bash
./testauth.sh 172.17.0.9
```

### Cassandra

```bash
./showcassandrastatus.sh

./showcustomertable.sh
```

## 名前解決の確認

```bash
dig @172.17.42.1 +short zuul.*.local.flyacmeair.net
dig @172.17.42.1 +short eureka.*.local.flyacmeair.net
dig @172.17.42.1 +short cassandra1.*.local.flyacmeair.net
dig @172.17.42.1 +short webapp1.*.local.flyacmeair.net
dig @172.17.42.1 +short auth1.*.local.flyacmeair.net
```

## うまく動かない時
Dockerのバージョンを確認します。この説明の前提と違うことがあります。

```bash
$ docker version
Client version: 1.0.0
Client API version: 1.12
Go version (client): go1.2.1
Git commit (client): 63fe64c
Server version: 1.0.0
Server API version: 1.12
Go version (server): go1.2.1
Git commit (server): 63fe64c
```

DockerデーモンのTCPソケットが有効でないかもしれません。Dockerデーモンの設定を確認して下さい。

```bash
$ ps -ef | grep docker
root     22320     1  0 14:06 ?        00:01:00 /usr/bin/docker -d -H tcp://0.0.0.0:2375 -H unix://var/run/docker.sock
```

ファイアーウォールがコンテナとDockerデーモンの通信を止めているかもしれません。ファイアーウォールの設定を確認して下さい。

SkyDockがうまく動いていないかもしれません。`skydock`を再起動してみてください。SkyDockは起動時にその時動作しているコンテナをすべてDNSに登録するので、他のコンテナを再起動する必要はありません。

```bash
docker restart skydock
```

期待と異なるDockerイメージが作成されているかもしれません。以下ののコマンドですべてのイメージを削除できます。注意: 以下のコマンドはすべてのコンテナとイメージを削除します。

```bash
docker rm -f `docker ps -qa`
docker rmi `docker images -q`
```

## 使用するソフトウェアのバージョン
|Image|Name|Version|Format|Source|
|-----|----|------|------|-------|
|asgard|Asgard|latest (dockerlocal branch)|binary|https://acmeair.ci.cloudbees.com/job/asgard-etiport/|
|asgard|MongoDB|2.4.9|binary|Ubuntu repository|
|auth-service|NetflixOSS Acme Air|latest (astyanax branch)|binary|https://acmeair.ci.cloudbees.com/job/acmeair-netflix-astyanax/|
|base|Oracle Java|7|binary|https://launchpad.net/~webupd8team/+archive/java/|
|base|ruby|1.9.3|binary|Ubuntu repository|
|base|sshd|6.6|binary|Ubuntu repository|
|base|supervisor|3.0|binary|Ubuntu repository|
|base|Ubuntu Linux|14.04|binary|[Docker Index](https://index.docker.io/)|
|cassandra|Cassandra|2.0.7|binary|http://cassandra.apache.org/|
|eureka|Eureka server|1.1.132|binary|Maven Central Repository|
|ibmjava|IBM Java|7.0 SR5|binary|https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/jre/index.yml|
|liberty|IBM WebSphere Application Server Liberty profile|8.5.5.2|binary|https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/index.yml|
|loader|Acme Air loader|latest (astyanax branch)|binary|https://acmeair.ci.cloudbees.com/job/acmeair-netflix-astyanax/|
|microscaler|Microscaler CLI|latest|source|https://github.com/EmergingTechnologyInstitute/microscaler/|
|microscaler|Microscaler|latest|source|https://github.com/EmergingTechnologyInstitute/microscaler/|
|microscaler|gnatsd|latest|source|https://github.com/apcera/gnatsd/|
|microscaler|Go|1.2.1|binary|Ubuntu repository|
|microscaler|MongoDB|2.4.9|binary|Ubuntu repository|
|microscaler|Redis|2.8.4|binary|Ubuntu repository|
|microscaler-agent|Microscaler Agent|latest|source|https://github.com/EmergingTechnologyInstitute/microscaler/|
|skydns|SkyDNS|latest|binary|[Docker Index](https://index.docker.io/)|
|skydock|SkyDock|latest|binary|[Docker Index](https://index.docker.io/)|
|tomcat|Tomcat|7.0.54|binary|http://tomcat.apache.org/|
|webapp|Acme Air|latest (astyanax branch)|binary|https://acmeair.ci.cloudbees.com/job/acmeair-netflix-astyanax/|
|zuul|Zuul|1.0.21|binary|Maven Central Repository|
