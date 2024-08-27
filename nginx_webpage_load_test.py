# This is a very basic script for load test
# Load will be generated based on command options
# For this testing commnad using:
# locust -f nginx_webpage_load_test.py --headless -u 15 -r 3 --run-time 30s --host="<nginx_ip>:<port>"

import time
from locust import HttpUser, TaskSet, task, between

class LoadTest(TaskSet):

    @task
    """
    Access main nginx page
    """
    def main_nginx_page(self):
        self.client.get('/')

class MainTest(HttpUser):
    """
    Call subclass LoadTest
    """
    tasks = [LoadTest]
    wait_time = between(5, 10)

