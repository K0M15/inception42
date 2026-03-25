BUILD_MARKER := .build_complete
SRC_FILES := srcs/docker-compose.yml srcs/requirements/mariadb/Dockerfile srcs/requirements/wordpress/Dockerfile srcs/requirements/nginx/Dockerfile
export DATA_PATH = $(CURDIR)/data/
# export DATA_PATH = /home/afelger/data/
export DOMAIN_NAME = afelger.42.fr

all: setup build run

build: $(BUILD_MARKER)

$(BUILD_MARKER): $(SRC_FILES)
	cd srcs && docker compose build
	touch $(BUILD_MARKER)

run:
	@echo "DATA_PATH: " $(DATA_PATH)
	@if [ "$(DEBUG)" = "TRUE" ]; then \
		cd srcs && docker compose up; \
	else \
		cd srcs && docker compose up -d; \
	fi
stop:
	cd srcs && docker compose down
setup:
	mkdir -p $(DATA_PATH)/wordpress
	mkdir -p $(DATA_PATH)/mariadb
clean:
	rm -f $(BUILD_MARKER)

re: clean all
	
