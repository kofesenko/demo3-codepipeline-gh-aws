FROM alpine:3.7
COPY requirements.txt /usr/src/app/
RUN apk add --update py2-pip; pip install --upgrade pip; pip install --no-cache-dir -r /usr/src/app/requirements.txt
COPY app.py /usr/src/app/
COPY templates/index.html /usr/src/app/templates/
EXPOSE 5000
ENTRYPOINT ["python","/usr/src/app/app.py"]