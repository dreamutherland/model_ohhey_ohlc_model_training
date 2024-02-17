### Deploy model_ohhey_ohlc_model_training via `DREAM cli`, `kubectl cli` or `docker` 

__via DREAM cli__ 
Simple way to deploy to k8s


```
dream models deploy model_ohhey_ohlc_model_training v1
```


__via kubectl directly__
Direct way to deploy to k8s


```
git clone --branch v1 --single-branch git@github.com:dreamutherland/model_ohhey_ohlc_model_training.git
kubectl create namespace serve-model-model-ohhey-ohlc-model-training
kubectl create -f mlflow-serving.yaml
kubectl expose deployment model_ohhey_ohlc_model_training-deployment --port [PORT] --type="LoadBalancer"
```


__via docker (local)__
Local way to quickly test the image


```
docker run -d -p PORT:PORT jleighsutherland/model_ohhey_ohlc_model_training:v1
```


### Test "model_ohhey_ohlc_model_training" by executing `./infer.sh` 

_This model predicts features:_

['jas_ohlc_extended__adj_close_normalised_change_1d']

__infer via infer.sh__ 


```
./infer.sh
```

