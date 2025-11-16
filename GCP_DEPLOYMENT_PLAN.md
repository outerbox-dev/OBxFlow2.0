# OBxFlow 2.0 - Google Cloud Platform Deployment Plan

**Target Platform:** Google Cloud Platform (GCP)  
**Deployment Method:** Cloud Run (Serverless Containers) + Cloud SQL (PostgreSQL)  
**Status:** Planning Phase

---

## 🎯 Deployment Architecture

### **Recommended: Cloud Run + Cloud SQL**

**Why Cloud Run?**
- ✅ Serverless container platform (no server management)
- ✅ Automatic scaling (0 to N instances)
- ✅ Pay only for usage
- ✅ Automatic HTTPS/SSL
- ✅ Built-in health checks
- ✅ Perfect for N8N

**Components:**
1. **Cloud Run** - N8N application container
2. **Cloud SQL** - Managed PostgreSQL database
3. **Cloud Storage** - Workflow data and backups
4. **Secret Manager** - Secure credential storage
5. **Cloud Build** - Automated deployments

---

## 📋 Prerequisites

### Tools Required
- [x] Docker - Already installed ✅
- [x] kubectl - Already installed ✅
- [ ] Google Cloud SDK (gcloud) - **Need to install**
- [ ] GCP Service Account - **Need credentials from you**

### GCP Services to Enable
1. Cloud Run API
2. Cloud SQL API
3. Cloud Build API
4. Secret Manager API
5. Cloud Storage API
6. Container Registry API

---

## 🔧 Installation Steps

### Step 1: Install Google Cloud SDK

```bash
# Install via Homebrew (recommended for Mac)
brew install google-cloud-sdk

# Or download installer
# https://cloud.google.com/sdk/docs/install

# Verify installation
gcloud --version
```

### Step 2: Authenticate

**Option A: Service Account (Recommended for automation)**
```bash
# You provide: service-account-key.json
gcloud auth activate-service-account --key-file=service-account-key.json
gcloud config set project YOUR_PROJECT_ID
```

**Option B: User Account (Interactive)**
```bash
gcloud auth login
gcloud config set project YOUR_PROJECT_ID
```

### Step 3: Enable Required APIs

```bash
gcloud services enable \
  run.googleapis.com \
  sqladmin.googleapis.com \
  cloudbuild.googleapis.com \
  secretmanager.googleapis.com \
  storage.googleapis.com \
  containerregistry.googleapis.com
```

---

## 🚀 Deployment Process

### Phase 1: Database Setup (Cloud SQL)

```bash
# Create PostgreSQL instance
gcloud sql instances create obxflow-db \
  --database-version=POSTGRES_14 \
  --tier=db-f1-micro \
  --region=us-central1 \
  --network=default \
  --enable-bin-log

# Create database
gcloud sql databases create n8n \
  --instance=obxflow-db

# Create database user
gcloud sql users create n8n_user \
  --instance=obxflow-db \
  --password=SECURE_PASSWORD
```

**Estimated Cost:** ~$9-25/month (db-f1-micro)

### Phase 2: Secret Management

```bash
# Store database password
echo -n "DB_PASSWORD" | gcloud secrets create n8n-db-password --data-file=-

# Store N8N encryption key
echo -n "ENCRYPTION_KEY" | gcloud secrets create n8n-encryption-key --data-file=-

# Store admin password
echo -n "ADMIN_PASSWORD" | gcloud secrets create n8n-admin-password --data-file=-
```

### Phase 3: Build & Push Container

```bash
# Tag image for GCP Container Registry
docker tag n8nio/n8n:latest gcr.io/PROJECT_ID/obxflow-n8n:latest

# Configure Docker for GCP
gcloud auth configure-docker

# Push to Container Registry
docker push gcr.io/PROJECT_ID/obxflow-n8n:latest
```

### Phase 4: Deploy to Cloud Run

```bash
# Deploy N8N to Cloud Run
gcloud run deploy obxflow \
  --image=gcr.io/PROJECT_ID/obxflow-n8n:latest \
  --platform=managed \
  --region=us-central1 \
  --allow-unauthenticated \
  --memory=512Mi \
  --cpu=1 \
  --timeout=3600 \
  --set-env-vars="N8N_PROTOCOL=https,N8N_PORT=443" \
  --set-secrets="DB_PASSWORD=n8n-db-password:latest,N8N_ENCRYPTION_KEY=n8n-encryption-key:latest" \
  --add-cloudsql-instances=PROJECT_ID:us-central1:obxflow-db
```

### Phase 5: Custom Domain (Optional)

```bash
# Map custom domain
gcloud run domain-mappings create \
  --service=obxflow \
  --domain=obxflow.outerbox.com \
  --region=us-central1
```

---

## 💰 Cost Estimation

### Cloud Run
- **Free tier:** 2 million requests/month
- **After free tier:** ~$0.40 per million requests
- **Estimated:** $5-15/month (with light usage)

### Cloud SQL (PostgreSQL)
- **db-f1-micro:** ~$9/month (shared CPU, 0.6GB RAM)
- **db-g1-small:** ~$25/month (shared CPU, 1.7GB RAM)
- **db-n1-standard-1:** ~$50/month (1 vCPU, 3.75GB RAM)

### Cloud Storage
- **Standard Storage:** $0.02/GB/month
- **Estimated:** $1-3/month

### Total Monthly Cost: ~$15-40/month (depending on tier)

---

## 🔐 Security Configuration

### Network Security
```bash
# Create VPC connector for secure DB access
gcloud compute networks vpc-access connectors create obxflow-connector \
  --network=default \
  --region=us-central1 \
  --range=10.8.0.0/28
```

### Firewall Rules
```bash
# Allow only Cloud Run to access Cloud SQL
gcloud sql instances patch obxflow-db \
  --authorized-networks=0.0.0.0/0 \
  --require-ssl
```

### SSL/TLS
- ✅ Automatic SSL certificates via Cloud Run
- ✅ Automatic renewal
- ✅ No configuration needed

---

## 📊 Monitoring & Logging

### Cloud Logging
```bash
# View logs
gcloud run services logs read obxflow --region=us-central1

# Tail logs
gcloud run services logs tail obxflow --region=us-central1
```

### Cloud Monitoring
- Automatic metrics collection
- CPU, Memory, Request count
- Custom dashboards available

---

## 🔄 CI/CD Pipeline (Cloud Build)

Create `cloudbuild.yaml`:

```yaml
steps:
  # Build container
  - name: 'gcr.io/cloud-builders/docker'
    args: ['build', '-t', 'gcr.io/$PROJECT_ID/obxflow-n8n:$COMMIT_SHA', '.']
  
  # Push to Container Registry
  - name: 'gcr.io/cloud-builders/docker'
    args: ['push', 'gcr.io/$PROJECT_ID/obxflow-n8n:$COMMIT_SHA']
  
  # Deploy to Cloud Run
  - name: 'gcr.io/cloud-builders/gcloud'
    args:
      - 'run'
      - 'deploy'
      - 'obxflow'
      - '--image=gcr.io/$PROJECT_ID/obxflow-n8n:$COMMIT_SHA'
      - '--region=us-central1'
      - '--platform=managed'

images:
  - 'gcr.io/$PROJECT_ID/obxflow-n8n:$COMMIT_SHA'
```

---

## 📋 What I Need From You

### 1. GCP Project Information
- [ ] Project ID (e.g., `outerbox-automation-12345`)
- [ ] Preferred region (e.g., `us-central1`, `us-east1`)
- [ ] Billing account confirmation

### 2. Authentication Method

**Option A: Service Account (Recommended)**
- [ ] Create service account in GCP Console
- [ ] Grant roles:
  - Cloud Run Admin
  - Cloud SQL Admin
  - Secret Manager Admin
  - Storage Admin
  - Service Account User
- [ ] Download JSON key file
- [ ] Provide to me securely

**Option B: OAuth Token**
- [ ] You run: `gcloud auth login`
- [ ] You run: `gcloud auth application-default login`
- [ ] Share project details

### 3. Domain Configuration (Optional)
- [ ] Custom domain (e.g., `obxflow.outerbox.com`)
- [ ] DNS access for verification

---

## 🎯 Deployment Timeline

**Phase 1: Setup (30 mins)**
- Install gcloud CLI
- Authenticate
- Enable APIs
- Verify access

**Phase 2: Infrastructure (20 mins)**
- Create Cloud SQL instance
- Configure networking
- Set up secrets

**Phase 3: Deployment (15 mins)**
- Build container
- Push to registry
- Deploy to Cloud Run

**Phase 4: Configuration (20 mins)**
- Apply OuterBox branding
- Test integrations
- Configure monitoring

**Phase 5: DNS & Domain (10 mins)** *(Optional)*
- Map custom domain
- Configure SSL

**Total: ~90-120 minutes**

---

## 🚀 Next Steps

1. **Install Google Cloud SDK**
   ```bash
   brew install google-cloud-sdk
   ```

2. **Provide Authentication**
   - Service account JSON key (preferred)
   - OR project ID for OAuth login

3. **Confirm Configuration**
   - Project name/ID
   - Preferred region
   - Database tier preference
   - Custom domain (optional)

4. **Begin Deployment**
   - I'll execute all commands via local-dev-bridge
   - Real-time progress updates
   - Automatic rollback if issues occur

---

## 📞 Ready to Deploy?

**Please provide:**

1. **GCP Project ID:** `_________________`
2. **Authentication:** (Service account JSON or "I'll login via OAuth")
3. **Region Preference:** (us-central1, us-east1, us-west1, etc.)
4. **Database Tier:** (db-f1-micro, db-g1-small, db-n1-standard-1)
5. **Custom Domain:** (optional: obxflow.outerbox.com or similar)

**Once you provide these, I'll begin the automated deployment process!**

---

**Status:** ⏳ Awaiting GCP credentials and project information
