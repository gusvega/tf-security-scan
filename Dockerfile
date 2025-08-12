FROM node:20

LABEL org.opencontainers.image.title="Terraform Security Scan"
LABEL org.opencontainers.image.description="Run tfsec and trivy"
LABEL org.opencontainers.image.authors="Gus Vega <github.com/gusvega>"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y curl wget gnupg lsb-release && rm -rf /var/lib/apt/lists/*

# Install tfsec
RUN curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash -s -- -b /usr/local/bin latest

# Install Trivy
RUN set -eux; \
    apt-get update && apt-get install -y apt-transport-https gnupg; \
    wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor -o /usr/share/keyrings/trivy.gpg; \
    echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" > /etc/apt/sources.list.d/trivy.list; \
    apt-get update && apt-get install -y trivy && rm -rf /var/lib/apt/lists/*

WORKDIR /github/workspace

COPY . /action
WORKDIR /action

RUN npm install

ENTRYPOINT ["node", "/action/index.js"]
