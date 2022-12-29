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

### Part 2