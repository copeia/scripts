.PHONY: run test coverage clean

run:
	python main.py

test:
	python -m unittest discover -s tests

coverage:
	coverage run -m unittest discover -s tests
	coverage report -m
	coverage html
	@echo "HTML coverage report generated in htmlcov/index.html"

clean:
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -exec rm -r {} +
	rm -rf htmlcov .coverage
