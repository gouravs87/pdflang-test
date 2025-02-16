# Use an official Python runtime as a parent image
FROM python:3.9-buster

# Install GCC and other dependencies
#RUN apt-get update && \
#    apt-get install -y gcc && \
#    rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the requirements file into the container
COPY requirements.txt ./

# Install the required packages
RUN pip install --no-cache-dir -r requirements.txt

# Copy the current directory contents into the container at /usr/src/app
COPY . .

# Make port 80 available to the world outside this container
EXPOSE 80

# Run myscripy.py when the container launches
CMD ["python", "./main.py"]