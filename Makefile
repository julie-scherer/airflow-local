# make airflow local
.PHONY: airflow run
airflow run:
	make pids die
	chmod +x scripts/run-airflow-locally.sh
	scripts/run-airflow-locally.sh


# make dir clean
.PHONY: dir clean
dir clean:
	chmod +x scripts/clean-working-dir.sh
	scripts/clean-working-dir.sh


# make pids die
.PHONY: pids die
pids die:
	chmod +x scripts/release-port-8080.sh
	scripts/release-port-8080.sh

