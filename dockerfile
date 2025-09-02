# Use official Python image
FROM python:3.11-slim
# Set working directory
WORKDIR /app
# Copy requirements first for caching
COPY requirements.txt .
# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt
# Copy the rest of the code
COPY . .
# Expose port
EXPOSE 8000
# Run server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]