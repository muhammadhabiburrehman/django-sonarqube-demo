# Use official Python image
FROM python:3.11-slim

# Install security updates
RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements first for caching
COPY requirements.txt .

# Install security updates and upgrade setuptools
RUN pip install --no-cache-dir --upgrade pip setuptools>=78.1.1

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the code
COPY . .

# Create non-root user for security
RUN addgroup --system django && adduser --system --group django

# Change ownership of the app directory
RUN chown -R django:django /app

# Switch to non-root user
USER django

# Expose port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD python -c "import requests; requests.get('http://localhost:8000')" || exit 1

# Run server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]