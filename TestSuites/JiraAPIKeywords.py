"""
Jira API Keywords Library for Robot Framework
Provides keywords for interacting with Jira REST API
"""

import requests
import json
from datetime import datetime
from robot.api.logger import info, warn, error
from robot.api.deco import keyword
from requests.auth import HTTPBasicAuth
import urllib3

# Disable SSL warnings for development
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)


class JiraAPIKeywords:
    """
    Robot Framework keyword library for Jira API interactions
    """

    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    def __init__(self):
        self.base_url = None
        self.username = None
        self.token = None
        self.session = None
        self.auth = None

    @keyword('Initialize Jira Connection')
    def initialize_jira_connection(self, base_url, username, token):
        """
        Initialize connection to Jira instance

        Args:
            base_url: Jira base URL (e.g., https://company.atlassian.net)
            username: Jira username/email
            token: Jira API token
        """
        self.base_url = base_url.rstrip('/')
        self.username = username
        self.token = token
        self.auth = HTTPBasicAuth(username, token)

        # Create session for connection pooling
        self.session = requests.Session()
        self.session.auth = self.auth
        self.session.headers.update({
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        })

        info(f"Initialized Jira connection to {self.base_url}")
        return True

    @keyword('Fetch Jira Issues With JQL')
    def fetch_jira_issues_with_jql(self, jql_query, fields=None, max_results=1000):
        """
        Fetch Jira issues using JQL query

        Args:
            jql_query: JQL query string
            fields: List of fields to retrieve (optional)
            max_results: Maximum number of results to return

        Returns:
            Dictionary containing issues data
        """
        if not self.session:
            raise Exception("Jira connection not initialized. Call 'Initialize Jira Connection' first.")

        # Default fields if none specified
        if fields is None:
            fields = ['key', 'summary', 'status', 'assignee', 'created', 'priority', 'description']

        # Build API URL
        api_url = f"{self.base_url}/rest/api/3/search"

        # Build query parameters
        params = {
            'jql': jql_query,
            'maxResults': max_results,
            'fields': ','.join(fields) if isinstance(fields, list) else fields,
            'startAt': 0
        }

        info(f"Executing JQL query: {jql_query}")
        info(f"Fields requested: {fields}")

        try:
            response = self.session.get(api_url, params=params, verify=False, timeout=30)
            response.raise_for_status()

            data = response.json()
            info(f"Successfully fetched {data.get('total', 0)} issues")

            return data

        except requests.exceptions.RequestException as e:
            error(f"Failed to fetch Jira issues: {str(e)}")
            raise Exception(f"Jira API request failed: {str(e)}")

    @keyword('Fetch Jira Issues With Pagination')
    def fetch_jira_issues_with_pagination(self, jql_query, max_results=50, start_at=0, fields=None):
        """
        Fetch Jira issues with pagination support

        Args:
            jql_query: JQL query string
            max_results: Maximum results per page
            start_at: Starting index for pagination
            fields: List of fields to retrieve

        Returns:
            Dictionary containing paginated issues data
        """
        if not self.session:
            raise Exception("Jira connection not initialized. Call 'Initialize Jira Connection' first.")

        # Default fields if none specified
        if fields is None:
            fields = ['key', 'summary', 'status', 'assignee', 'created', 'priority']

        api_url = f"{self.base_url}/rest/api/3/search"

        params = {
            'jql': jql_query,
            'maxResults': max_results,
            'startAt': start_at,
            'fields': ','.join(fields) if isinstance(fields, list) else fields
        }

        info(f"Fetching paginated results: start={start_at}, max={max_results}")

        try:
            response = self.session.get(api_url, params=params, verify=False, timeout=30)
            response.raise_for_status()

            data = response.json()
            info(f"Paginated fetch successful: {len(data.get('issues', []))} issues returned")

            return data

        except requests.exceptions.RequestException as e:
            error(f"Failed to fetch paginated Jira issues: {str(e)}")
            raise Exception(f"Jira API pagination request failed: {str(e)}")

    @keyword('Fetch All Jira Issues')
    def fetch_all_jira_issues(self, jql_query, fields=None, batch_size=100):
        """
        Fetch all Jira issues using pagination to handle large result sets

        Args:
            jql_query: JQL query string
            fields: List of fields to retrieve
            batch_size: Number of issues to fetch per batch

        Returns:
            Dictionary containing all issues data
        """
        if not self.session:
            raise Exception("Jira connection not initialized. Call 'Initialize Jira Connection' first.")

        # Default fields if none specified
        if fields is None:
            fields = ['key', 'summary', 'status', 'assignee', 'created', 'priority', 'description']

        all_issues = []
        start_at = 0
        total_issues = None

        info(f"Starting to fetch all issues with JQL: {jql_query}")

        while True:
            batch_data = self.fetch_jira_issues_with_pagination(
                jql_query, batch_size, start_at, fields
            )

            if total_issues is None:
                total_issues = batch_data.get('total', 0)
                info(f"Total issues to fetch: {total_issues}")

            issues = batch_data.get('issues', [])
            all_issues.extend(issues)

            info(f"Fetched batch: {len(issues)} issues (Total so far: {len(all_issues)})")

            # Check if we've fetched all issues
            if len(all_issues) >= total_issues or len(issues) < batch_size:
                break

            start_at += batch_size

        result = {
            'total': len(all_issues),
            'issues': all_issues,
            'maxResults': batch_size,
            'startAt': 0
        }

        info(f"Successfully fetched all {len(all_issues)} issues")
        return result

    @keyword('Get Issue By Key')
    def get_issue_by_key(self, issue_key, fields=None):
        """
        Get a specific Jira issue by its key

        Args:
            issue_key: Jira issue key (e.g., PROJECT-123)
            fields: List of fields to retrieve

        Returns:
            Dictionary containing issue data
        """
        if not self.session:
            raise Exception("Jira connection not initialized. Call 'Initialize Jira Connection' first.")

        api_url = f"{self.base_url}/rest/api/3/issue/{issue_key}"

        params = {}
        if fields:
            params['fields'] = ','.join(fields) if isinstance(fields, list) else fields

        info(f"Fetching issue: {issue_key}")

        try:
            response = self.session.get(api_url, params=params, verify=False, timeout=30)
            response.raise_for_status()

            data = response.json()
            info(f"Successfully fetched issue: {issue_key}")

            return data

        except requests.exceptions.RequestException as e:
            error(f"Failed to fetch issue {issue_key}: {str(e)}")
            raise Exception(f"Jira API request failed for issue {issue_key}: {str(e)}")

    @keyword('Validate Jira Connection')
    def validate_jira_connection(self):
        """
        Validate the Jira connection by calling the /myself endpoint

        Returns:
            Dictionary containing current user information
        """
        if not self.session:
            raise Exception("Jira connection not initialized. Call 'Initialize Jira Connection' first.")

        api_url = f"{self.base_url}/rest/api/3/myself"

        info("Validating Jira connection...")

        try:
            response = self.session.get(api_url, verify=False, timeout=30)
            response.raise_for_status()

            user_data = response.json()
            info(f"Connection validated successfully. User: {user_data.get('displayName', 'Unknown')}")

            return user_data

        except requests.exceptions.RequestException as e:
            error(f"Jira connection validation failed: {str(e)}")
            raise Exception(f"Jira connection validation failed: {str(e)}")

    @keyword('Execute Custom JQL')
    def execute_custom_jql(self, jql_query, expand=None, fields=None, max_results=50):
        """
        Execute a custom JQL query with advanced options

        Args:
            jql_query: JQL query string
            expand: Comma-separated list of fields to expand
            fields: List of fields to retrieve
            max_results: Maximum number of results

        Returns:
            Dictionary containing query results
        """
        if not self.session:
            raise Exception("Jira connection not initialized. Call 'Initialize Jira Connection' first.")

        api_url = f"{self.base_url}/rest/api/3/search"

        params = {
            'jql': jql_query,
            'maxResults': max_results
        }

        if expand:
            params['expand'] = expand

        if fields:
            params['fields'] = ','.join(fields) if isinstance(fields, list) else fields

        info(f"Executing custom JQL: {jql_query}")
        if expand:
            info(f"Expanding fields: {expand}")

        try:
            response = self.session.get(api_url, params=params, verify=False, timeout=30)
            response.raise_for_status()

            data = response.json()
            info(f"Custom JQL executed successfully. Results: {data.get('total', 0)} issues")

            return data

        except requests.exceptions.RequestException as e:
            error(f"Custom JQL execution failed: {str(e)}")
            raise Exception(f"Custom JQL execution failed: {str(e)}")

    @keyword('Extract Text From ADF')
    def extract_text_from_adf(self, adf_content):
        """
        Extract plain text from Atlassian Document Format (ADF)

        Args:
            adf_content: ADF content dictionary

        Returns:
            Plain text string
        """
        if not adf_content or not isinstance(adf_content, dict):
            return ''

        text = ''
        content = adf_content.get('content', [])

        for item in content:
            if item.get('type') == 'paragraph':
                paragraph_content = item.get('content', [])
                for text_item in paragraph_content:
                    if text_item.get('type') == 'text':
                        text += text_item.get('text', '') + ' '
            elif item.get('type') == 'text':
                text += item.get('text', '') + ' '

        return text.strip()

    def close_connection(self):
        """Close the Jira session"""
        if self.session:
            self.session.close()
            self.session = None
            info("Jira connection closed")
