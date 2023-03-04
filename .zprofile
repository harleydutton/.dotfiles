#KEYCHAIN
eval $(keychain -k others --clear --eval --noask github)

#PATH
export PATH=/Users/P2996224/Tools/apache-maven-3.9.0/bin:$PATH
export PATH=/opt/homebrew/bin:$PATH

#JAVA
java8(){ export JAVA_HOME=`/usr/libexec/java_home -v 1.8` }
java11(){ export JAVA_HOME=`/usr/libexec/java_home -v 11.0` }
java15(){ export JAVA_HOME=`/usr/libexec/java_home -v 15.0` }
java17(){ export JAVA_HOME=`/usr/libexec/java_home -v 17.0` }
java19(){ export JAVA_HOME=`/usr/libexec/java_home -v 19.0` }
java11
export PATH="$PATH:$JAVA_HOME/bin"

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
globald
