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
START_ECHO=echo "$(GREEN)$(BOLD)[INFO] start $@ $$s $(RESET)"

.PHONY: build
build:
	@ $(START_ECHO);\
	cd $(BUILD_DIR); \
	GOOS=linux GOARCH=amd64 go build -o $(BIN_NAME) *.go

.PHONY: deploy-app
deploy-app: build
	@ for s in s1 s2 s3 s4 s5; do\
		$(START_ECHO);\
		ssh $$s "sudo systemctl daemon-reload";\
		ssh $$s "sudo systemctl stop $(SERVICE_NAME)";\
		scp $(BUILD_DIR)/$(BIN_NAME) $$s:$(SERVER_BINARY_DIR);\
		ssh $$s "sudo systemctl start $(SERVICE_NAME)";\
	done

# 当日ファイル名をいじる
.PHONY: deploy-sql
deploy-sql:
	@ for s in s1 s2 s3 s4 s5; do\
		$(START_ECHO);\
		scp sql/3_schema_exclude_user_presents.sql $$s:~/webapp/sql/3_schema_exclude_user_presents.sql;\
		scp sql/6_id_generator_init.sql $$s:~/webapp/sql/6_id_generator_init.sql;\
		scp sql/init.sh $$s:~/webapp/sql/init.sh;\
		scp sql/setup/0_setup.sql $$s:~/webapp/sql/setup/0_setup.sql;\
		scp sql/setup/1_schema.sql $$s:~/webapp/sql/setup/1_schema.sql;\
	done

.PHONY: deploy-config
deploy-config:
	@ for s in s1 s2 s3 s4 s5; do\
		$(START_ECHO);\
		cd $$s && ./deploy.sh && cd -;\
	done

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
