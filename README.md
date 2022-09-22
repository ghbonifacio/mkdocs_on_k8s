# Mkdocs on Kubernetes
This project aims to present a way to deploy MKDocs (https://www.mkdocs.org) in a Kubernetes cluster.


## Quick Start
Initially you need to install mkdocs locally
```
sudo apt install mkdocs
```


Then, directories were created to allocate the new MKDocs project and finally this one was created.
```
mkdir projeto
cd projeto
mkdocs new docs
```


After creating the project, it is necessary to build the image with MKDocs.
```
mkdocs build
```

After this step, a folder will be generated containing all the files of the static site. So, just create the Dockerfile that will create the image that will be built. In this file, we use an image of Nginx alphine and just copy the folder created, after the mkdcos build, to the html path. 

Create new file dockefile
```
FROM nginx:alpine
COPY projeto/site/ /usr/share/nginx/html/
EXPOSE 80
```

With the dockerfile created, just run the command below to build the image locally
```
docker build -t testemkdocs .
```

After this process, you can allocate this image where convenient, for practical purposes, I will add it to the docker hub.

You need to authenticate to ducker hub to push an image
```
docker login
```

After authentication, just create the tag of your docker image
```
docker tag mkdocsteste:latest ghenriquee/dockerhub:mkdocsteste
```

And push it
```
docker push
```

With the image built and already in dockerhub, just create the deployment file,
First we need to define the deployment of the app to be created
```
apiVersion: apps/v1 # for versions before 1.9.0 use apps/v1beta2 
kind: Deployment 
metadata: 
  name: mkdocs
spec: 
  selector: 
    matchLabels: 
      app: mkdocs 
  replicas: 1 # tells deployment to run 2 pods matching the template 
  template: 
    metadata: 
      labels: 
        app: mkdocs 
    spec: 
      containers: 
      - name: mkdocs 
        image: ghenriquee/dockerhub:mkdocsteste
        ports: 
        - containerPort: 8000
```

And after defining service for the same
```
kind: Service 
apiVersion: v1 
metadata: 
  name: mkdocs-service 
spec: 
  selector: 
    app: mkdocs 
  ports: 
  - protocol: TCP 
    port: 8000
    targetPort: 8000
  type: ClusterIP 
```

With that, to apply this file to your cluster.
```
kubectl apply -f deployment.yaml -n namespace
```

After applying, you will find the pod and service attached to MKDocs in your cluster. Finally you can use a port-forward to access the image locally,
```
kubectl port-forward svc/mkdocs-service 8080:8000
```

With this, you can also manage access via LoadBalancer or even with an internal LoadBalancer applying a manifest.

Created by Gabriel Bonifácio. Feel free to contact me!
[![Linkedin Badge](https://img.shields.io/badge/-Gabriel_Bonifacio-blue?style=flat-square&logo=Linkedin&logoColor=white&link=https://www.linkedin.com/in/gabriel-bonifacio/)](https://www.linkedin.com/in/gabriel-bonifacio/)
[![Gmail Badge](https://img.shields.io/badge/-ghenriquee@live.com-c14438?style=flat-square&logo=Gmail&logoColor=white&link=mailto:ghenriquee@live.com)](mailto:ghenriquee@live.com)