### Part 1

Installing K3S on server and server worker

- First, we have to create two different machines, one for the server and one for the server worker. I used alpine linux for both of them because it's weightless. In a Vagrantfile, you have to add the following lines to specify an image:
    
    ```ruby
    config.vm.box = "generic/alpine312"
    ```
    
    Then, you have to run the following command to create the machines:
    
    ```bash
    vagrant up # (or vagrant up <machine_name> if you don´t want to create both machines)
    ```
    Here you go, you have your machine running on alpine linux.

    You will also have to specify the IP address of your machines. By example, let's say that I want to create a server on alpine312 with the IP address 192.42.42.42

    ```ruby
    config.vm.define "server" do |alpine312|
        server.vm.box = "generic/alpine312"
        server.vm.network "private_network", ip: "192.42.42.42"
    end
    ```

- Now, we have to install K3S on our server. To do that, we have to connect to our server machine and run the following command:
    
    ```bash
    curl -sfL https://get.k3s.io | sh -
    ```
    You can also specify some options to install K3S, by example if you want to be in server or agent mode. You can find more information about the options [here](https://docs.k3s.io/installation/configuration).
    
    ```bash
    export K3S_INSTALL_K3S_EXEC="--server --node-ip 192.42.42.42"
    ```

    Here you go, you have your server running K3S. You can check if it's running by running the following command:
    
    ```bash
    kubectl get nodes -o wide
    ```


- Now, we have to install K3S on our server worker. To do that, we have to connect to our server worker machine and run the following command:
    
    ```bash
    curl -sfL https://get.k3s.io | sh -
    ```
    You will have to give more informations to it, like the token of your server, I won't explain you how to get it but think about shared folders...

- Now, you have to connect to your server and run the following command:
    
    ```bash
    kubectl get nodes -o wide
    ```
    You should see your server worker in the list.
---
### Part 2

##### Creating apps with K3S

- In this part, we will only keep the server, we will create some apps and deploy them on our server.

    To deploy an app, we will use the following command:
    
    ```bash
    kubectl apply -f <file_name>
    ```
   The applications are yaml files, you can find some examples [here](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/).
   I used the hello-kubernetes application available [here](https://hub.docker.com/r/paulbouwer/hello-kubernetes/)
   
 - In your second app, you will have to set 3 replicas of your app. To do that, you will have to add the following line to your yaml file:
    
    ```yaml
    replicas: 3
    ```

    Replicas are useful when you want to have a high availability of your app. If one of your app is down, the other one will take its place.

    You will also have to redirect different hosts to differents apps. By example, if in the request the host is "app1.com" I will redirect to app-1. To do that, you will have to add the following line to your yaml file:
    
    ```yaml
    host: app1.com
    ```
    And to test it, you will have to use curl:
    
    ```bash
    curl -X GET -H "Host: app1.com" <server_ip>
    ```
    Finally, you will have to redirect to the app3 when there is no host specified.
---

Let's do a recap of what we used for now:

| Tool                    | Usage                    |
|----------------------------|----------------------------------|
|K3s                      | Kubernetes light version, it's a container orchestrator. It's used to deploy apps on a server.|
|kubectl                  | It's a command line tool to manage your k3s server.|
|Vagrant                  | It's a tool to create virtual machines.|
### Part 3

Now, we will learn new tools, K3D and docker.

To use K3D, you will need a docker version >= 20.1.X so we can't use alpine linux anymore. We will use ubuntu instead.

- First we have to install docker, you can find an explanation [here](https://docs.docker.com/engine/install/ubuntu/).

- Now, we have to install K3D, you can find an explanation [here](https://k3d.io/).


Now, we will create a cluster and two namespaces, one for argocd and the other one for our apps.

- To create a cluster, you will have to run the following command:
    
    ```bash
    k3d cluster create <cluster_name>
    ```
- To create a namespace, you will have to run the following command:
    
    ```bash
    kubectl create namespace <namespace_name>
    ```
- After that, we will need to install argocd, the yaml to install it is available [here](https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml).

To create an app in a namespace, you will have to use the following command:
    
    ```bash
    kubectl apply -f <file_name> -n <namespace_name>
    ```

After that, you will be able to create the port forwarding to access argocd. To do that, you will have to run the following command:
    
    ```bash
    kubectl port-forward svc/argocd-server -n argocd 8080:443
    ```
>But before doing it, you will need to wait for all the pods to be ready and get the admin password. I won't explain how to do it, you will have to find it by yourself.

- Now, you will be able to access argocd by going to the following url: https://192.42.42.42:8080

In argocd, you will have to create a new project, you will have to give it a name, a repository and a description. You will also have to specify the namespace where you want to deploy your apps.

After that, you should save the yaml file in order to be able to deploy it later, directly from argocd.


---

Let's do a second recap with the new tools:

| Tool                    | Usage                    |
|----------------------------|----------------------------------|
|K3D                      | Kubernetes light version, it's a container orchestrator. It's used to deploy apps on a server.|
|Dockers                  | It's a containerization tool.|
|ArgoCD                  | It's a tool to deploy apps on a kubernetes cluster.|

---
### Bonus

##### Creating a CI/CD pipeline with Gitlab

- The bonus part is to create a CI/CD pipeline with our builded version of Gitlab, it will be used to deploy our app with Gitlab.
    - First, we will need to install helm, it's a package manager for kubernetes. You can find an explanation [here](https://helm.sh/docs/intro/install/).
    - After that, we will use helm to install gitlab on our cluster. You can find the yaml file [here](https://docs.gitlab.com/charts/installation/deployment.html) and [here](https://docs.gitlab.com/charts/installation/command-line-options.html).

