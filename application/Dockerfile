FROM python:3-alpine


RUN pip3 install flask


COPY flaskapp/app.py .
COPY flaskapp/__pycache__/ __pycache__/
COPY flaskapp/static/ static/


EXPOSE 5000


CMD flask run --host=0.0.0.0
