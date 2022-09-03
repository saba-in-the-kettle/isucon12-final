# make deploy -j 15 で並列でデプロイされる

# ↓↓↓当日いじる↓↓↓
# アプリケーション
BUILD_DIR:=./go# ローカルマシンのMakefileからの相対パス
BIN_NAME:=isuconquest
SERVER_BINARY_DIR:=~/webapp/go
SERVICE_NAME:=isuconquest.go.service
# ↑↑↑ここまで↑↑↑

# colors
ESC=$(shell printf '\033')
RESET="${ESC}[0m"
BOLD="${ESC}[1m"
RED="${ESC}[31m"
GREEN="${ESC}[32m"
BLUE="${ESC}[33m"

# commands
START_ECHO=echo "$(GREEN)$(BOLD)[INFO] start $@ $* $(RESET)"

.PHONY: build
build:
	@ $(START_ECHO);\
	cd $(BUILD_DIR); \
	GOOS=linux GOARCH=amd64 go build -o $(BIN_NAME) *.go;\
   	echo "$(GREEN)$(BOLD)[INFO] complete build $(RESET)";\

.PHONY: deploy-app
deploy-app:
	@ $(MAKE) build
	@ $(MAKE) deploy-app-s1 deploy-app-s2 deploy-app-s3 deploy-app-s4 deploy-app-s5

deploy-app-%:
	@ $(START_ECHO);\
	ssh $* "~isucon/webapp/sql/setup/setup.sh";\

# 当日ファイル名をいじる
.PHONY: deploy-sql
deploy-sql: deploy-sql-s1 deploy-sql-s2 deploy-sql-s3 deploy-sql-s4 deploy-sql-s5

deploy-sql-%:
	@ $(START_ECHO);\
	scp sql/3_schema_exclude_user_presents.sql $*:~/webapp/sql/3_schema_exclude_user_presents.sql;\
	scp sql/6_id_generator_init.sql $*:~/webapp/sql/6_id_generator_init.sql;\
	scp sql/init.sh $*:~/webapp/sql/init.sh;\
	scp sql/setup/0_setup.sql $*:~/webapp/sql/setup/0_setup.sql;\
	scp sql/setup/1_schema.sql $*:~/webapp/sql/setup/1_schema.sql;\
	scp sql/setup/setup.sh $*:~/webapp/sql/setup/setup.sh;\

.PHONY: deploy-config
deploy-config: deploy-config-s1 deploy-config-s2 deploy-config-s3 deploy-config-s4 deploy-config-s5

deploy-config-%:
	@ $(START_ECHO);\
	cd $* && ./deploy.sh && cd -;\

.PHONY: deploy
deploy: deploy-config deploy-sql deploy-app


.PHONY: port-forward
port-forward:
	lsof -t -i :19999,29999,39999,49999,59999 | xargs kill
	ssh -N s1 -L 19999:localhost:19999 -L 9000:localhost:9000 -L 8080:localhost:80 -L 3307:localhost:3306 &
	ssh -N s2 -L 29999:localhost:19999 -L 3306:localhost:3306  &
	ssh -N s3 -L 39999:localhost:19999 &
	ssh -N s4 -L 49999:localhost:19999 &
	ssh -N s5 -L 59999:localhost:19999 &
