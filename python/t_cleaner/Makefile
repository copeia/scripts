.PHONY: run test coverage clean

clean:
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -exec rm -r {} +
	rm -rf htmlcov .coverage

coverage:
	coverage run -m unittest discover -s tests
	coverage report -m
	coverage html
	@echo "HTML coverage report generated in htmlcov/index.html"

fmt:
	pre-commit run --all-files

run:
	python main.py

# Install required dependencies
setup:
	pip3 install -r requirements.txt
	pre-commit install

test:
	python -m unittest discover -s tests