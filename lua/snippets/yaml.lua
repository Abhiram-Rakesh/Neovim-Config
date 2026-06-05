local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require('luasnip.extras.fmt').fmt

ls.add_snippets('yaml', {

  -- ── Kubernetes ────────────────────────────────────────────────────────

  s('k8s-deployment', fmt([[
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {}
  namespace: {}
  labels:
    app: {}
spec:
  replicas: {}
  selector:
    matchLabels:
      app: {}
  template:
    metadata:
      labels:
        app: {}
    spec:
      containers:
        - name: {}
          image: {}:{}
          ports:
            - containerPort: {}
          resources:
            requests:
              cpu: {}
              memory: {}
            limits:
              cpu: {}
              memory: {}
          envFrom:
            - configMapRef:
                name: {}-config
]], {
    i(1, 'my-app'), i(2, 'default'), i(3, 'my-app'),
    i(4, '2'),
    i(5, 'my-app'), i(6, 'my-app'), i(7, 'my-app'),
    i(8, 'my-image'), i(9, 'latest'), i(10, '8080'),
    i(11, '100m'), i(12, '128Mi'), i(13, '500m'), i(14, '512Mi'),
    i(15, 'my-app'),
  })),

  s('k8s-service', fmt([[
apiVersion: v1
kind: Service
metadata:
  name: {}
  namespace: {}
spec:
  selector:
    app: {}
  type: {}
  ports:
    - port: {}
      targetPort: {}
      protocol: TCP
]], { i(1, 'my-app'), i(2, 'default'), i(3, 'my-app'), i(4, 'ClusterIP'), i(5, '80'), i(6, '8080') })),

  s('k8s-ingress', fmt([[
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {}
  namespace: {}
  annotations:
    kubernetes.io/ingress.class: {}
spec:
  rules:
    - host: {}
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: {}
                port:
                  number: {}
  tls:
    - hosts:
        - {}
      secretName: {}-tls
]], { i(1, 'my-app'), i(2, 'default'), i(3, 'nginx'), i(4, 'app.example.com'), i(5, 'my-app'), i(6, '80'), i(7, 'app.example.com'), i(8, 'my-app') })),

  s('k8s-configmap', fmt([[
apiVersion: v1
kind: ConfigMap
metadata:
  name: {}-config
  namespace: {}
data:
  {}: {}
]], { i(1, 'my-app'), i(2, 'default'), i(3, 'KEY'), i(4, 'value') })),

  s('k8s-secret', fmt([[
apiVersion: v1
kind: Secret
metadata:
  name: {}-secret
  namespace: {}
type: Opaque
stringData:
  {}: {}
]], { i(1, 'my-app'), i(2, 'default'), i(3, 'SECRET_KEY'), i(4, 'value') })),

  s('k8s-pvc', fmt([[
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: {}
  namespace: {}
spec:
  accessModes:
    - {}
  storageClassName: {}
  resources:
    requests:
      storage: {}
]], { i(1, 'my-pvc'), i(2, 'default'), i(3, 'ReadWriteOnce'), i(4, 'standard'), i(5, '10Gi') })),

  s('k8s-namespace', fmt([[
apiVersion: v1
kind: Namespace
metadata:
  name: {}
  labels:
    name: {}
]], { i(1, 'my-namespace'), i(2, 'my-namespace') })),

  s('k8s-serviceaccount', fmt([[
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {}
  namespace: {}
  annotations:
    eks.amazonaws.com/role-arn: {}
]], { i(1, 'my-sa'), i(2, 'default'), i(3, 'arn:aws:iam::ACCOUNT_ID:role/my-role') })),

  s('k8s-role', fmt([[
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: {}
  namespace: {}
rules:
  - apiGroups: ["{}"]
    resources: ["{}"]
    verbs: ["get", "list", "watch"]
]], { i(1, 'my-role'), i(2, 'default'), i(3, ''), i(4, 'pods') })),

  s('k8s-rolebinding', fmt([[
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: {}
  namespace: {}
subjects:
  - kind: ServiceAccount
    name: {}
    namespace: {}
roleRef:
  kind: Role
  name: {}
  apiGroup: rbac.authorization.k8s.io
]], { i(1, 'my-rolebinding'), i(2, 'default'), i(3, 'my-sa'), i(4, 'default'), i(5, 'my-role') })),

  s('k8s-clusterrole', fmt([[
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: {}
rules:
  - apiGroups: ["{}"]
    resources: ["{}"]
    verbs: ["get", "list", "watch"]
]], { i(1, 'my-clusterrole'), i(2, ''), i(3, 'nodes') })),

  s('k8s-clusterrolebinding', fmt([[
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: {}
subjects:
  - kind: ServiceAccount
    name: {}
    namespace: {}
roleRef:
  kind: ClusterRole
  name: {}
  apiGroup: rbac.authorization.k8s.io
]], { i(1, 'my-crb'), i(2, 'my-sa'), i(3, 'default'), i(4, 'my-clusterrole') })),

  s('k8s-hpa', fmt([[
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: {}
  namespace: {}
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {}
  minReplicas: {}
  maxReplicas: {}
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: {}
]], { i(1, 'my-hpa'), i(2, 'default'), i(3, 'my-app'), i(4, '2'), i(5, '10'), i(6, '70') })),

  s('k8s-cronjob', fmt([[
apiVersion: batch/v1
kind: CronJob
metadata:
  name: {}
  namespace: {}
spec:
  schedule: "{}"
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: OnFailure
          containers:
            - name: {}
              image: {}:{}
              command: {}
]], { i(1, 'my-cronjob'), i(2, 'default'), i(3, '0 * * * *'), i(4, 'my-job'), i(5, 'my-image'), i(6, 'latest'), i(7, '["/bin/sh", "-c", "echo hello"]') })),

  s('k8s-networkpolicy', fmt([[
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: {}
  namespace: {}
spec:
  podSelector:
    matchLabels:
      app: {}
  policyTypes:
    - Ingress
    - Egress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: {}
      ports:
        - protocol: TCP
          port: {}
]], { i(1, 'my-netpol'), i(2, 'default'), i(3, 'my-app'), i(4, 'allowed-app'), i(5, '8080') })),

  -- ── ArgoCD ────────────────────────────────────────────────────────────

  s('argocd-app', fmt([[
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: {}
  namespace: argocd
spec:
  project: {}
  source:
    repoURL: {}
    targetRevision: {}
    path: {}
  destination:
    server: https://kubernetes.default.svc
    namespace: {}
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
]], { i(1, 'my-app'), i(2, 'default'), i(3, 'https://github.com/org/repo'), i(4, 'HEAD'), i(5, 'k8s/overlays/prod'), i(6, 'my-namespace') })),

  s('argocd-appset', fmt([[
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: {}
  namespace: argocd
spec:
  generators:
    - list:
        elements:
          - cluster: {}
            url: https://kubernetes.default.svc
  template:
    metadata:
      name: '{}-{{}cluster{}}'
    spec:
      project: {}
      source:
        repoURL: {}
        targetRevision: HEAD
        path: {}
      destination:
        server: '{{}url{}}'
        namespace: {}
]], { i(1, 'my-appset'), i(2, 'prod'), i(3, 'my-app'), i(4, 'default'), i(5, 'https://github.com/org/repo'), i(6, 'k8s/overlays/prod'), i(7, 'my-namespace') })),

  -- ── GitHub Actions ────────────────────────────────────────────────────

  s('gh-workflow', fmt([[
name: {}

on:
  push:
    branches: [{}]
  pull_request:
    branches: [{}]

env:
  {}

jobs:
  {}:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: {}
        run: {}
]], { i(1, 'CI'), i(2, 'main'), i(3, 'main'), i(4, 'ENV_VAR: value'), i(5, 'build'), i(6, 'Run build'), i(7, 'make build') })),

  s('gh-job', fmt([[
  {}:
    runs-on: ubuntu-latest
    needs: [{}]
    steps:
      - uses: actions/checkout@v4

      - name: {}
        run: |
          {}
]], { i(1, 'deploy'), i(2, 'build'), i(3, 'Deploy'), i(4, 'echo "deploying"') })),

  s('gh-docker-build', fmt([[
  build-push:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{{{ secrets.AWS_ACCESS_KEY_ID }}}}
          aws-secret-access-key: ${{{{ secrets.AWS_SECRET_ACCESS_KEY }}}}
          aws-region: {}

      - name: Login to ECR
        id: login-ecr
        uses: aws-actions/amazon-ecr-login@v2

      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          push: true
          tags: ${{{{ steps.login-ecr.outputs.registry }}}}/{}:${{{{ github.sha }}}}
]], { i(1, 'us-east-1'), i(2, 'my-image') })),

  s('gh-terraform', fmt([[
  terraform:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: {}
    steps:
      - uses: actions/checkout@v4

      - uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: {}

      - name: Terraform Init
        run: terraform init

      - name: Terraform Plan
        run: terraform plan -out=tfplan

      - name: Terraform Apply
        if: github.ref == 'refs/heads/main'
        run: terraform apply -auto-approve tfplan
]], { i(1, './terraform'), i(2, '1.9.0') })),

  -- ── GitLab CI ────────────────────────────────────────────────────────

  s('gl-pipeline', fmt([[
stages:
  - build
  - test
  - deploy

variables:
  {}: {}

default:
  image: {}
  tags:
    - {}

{}:
  stage: build
  script:
    - {}
  only:
    - {}
]], { i(1, 'IMAGE_TAG'), i(2, '$CI_COMMIT_SHORT_SHA'), i(3, 'alpine:latest'), i(4, 'docker'), i(5, 'build'), i(6, 'make build'), i(7, 'main') })),

  s('gl-job', fmt([[
{}:
  stage: {}
  image: {}
  script:
    - {}
  only:
    - {}
  artifacts:
    paths:
      - {}
    expire_in: {}
]], { i(1, 'my-job'), i(2, 'build'), i(3, 'alpine:latest'), i(4, 'echo "running"'), i(5, 'main'), i(6, 'dist/'), i(7, '1 hour') })),

  s('gl-docker-build', fmt([[
build-image:
  stage: build
  image: docker:24
  services:
    - docker:24-dind
  variables:
    DOCKER_TLS_CERTDIR: "/certs"
  script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - docker build -t $CI_REGISTRY_IMAGE/{}:$CI_COMMIT_SHA .
    - docker push $CI_REGISTRY_IMAGE/{}:$CI_COMMIT_SHA
  only:
    - {}
]], { i(1, 'my-image'), i(2, 'my-image'), i(3, 'main') })),

  -- ── Helm ─────────────────────────────────────────────────────────────

  s('helm-values', fmt([[
replicaCount: {}

image:
  repository: {}
  tag: {}
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: {}

ingress:
  enabled: {}
  className: {}
  hosts:
    - host: {}
      paths:
        - path: /
          pathType: Prefix

resources:
  requests:
    cpu: {}
    memory: {}
  limits:
    cpu: {}
    memory: {}

autoscaling:
  enabled: false
  minReplicas: 1
  maxReplicas: 10
  targetCPUUtilizationPercentage: 80
]], {
    i(1, '2'), i(2, 'my-image'), i(3, 'latest'),
    i(4, '80'),
    i(5, 'false'), i(6, 'nginx'), i(7, 'chart.example.local'),
    i(8, '100m'), i(9, '128Mi'), i(10, '500m'), i(11, '512Mi'),
  })),

})
