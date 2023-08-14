#PATH
export PATH=/Users/P2996224/Tools/apache-maven-3.9.0/bin:$PATH
export PATH=/opt/homebrew/bin:$PATH
export PATH=$PATH:/opt/homebrew/bin

#JAVA
java11(){ export JAVA_HOME=`/usr/libexec/java_home -v 11` }
java17(){ export JAVA_HOME=`/usr/libexec/java_home -v 17` }
java11
#export PATH="$PATH:$JAVA_HOME/bin"

#KUBERNETES
globalb(){
    export KUBECONFIG="$HOME/.kube/eks-rome-globalb_p2996224.config"
    kubectl config set-context --current --namespace=datadog
}
globald(){
    export KUBECONFIG="$HOME/.kube/eks-rome-globald_p2996224.config"
    kubectl config set-context --current --namespace=scl-dev
}
globale(){
    export KUBECONFIG="$HOME/.kube/eks-rome-globale_p2996224.config"
    kubectl config set-context --current --namespace=datadog
}
poc124(){
    export KUBECONFIG="$HOME/.kube/eks-rome-poc124_p2996224.config"
    kubectl config set-context --current --namespace=datadog
}
kclocal(){
    export KUBECONFIG="$HOME/.kube/config"
    kubectl config set-context --current
}
globald

#KEYCHAIN
eval `keychain -q -k others --eval ~/.ssh/id_ed25519 ~/.ssh/pi_id_ed25519`


# Added by Toolbox App
export PATH="$PATH:/Users/P2996224/Library/Application Support/JetBrains/Toolbox/scripts"

