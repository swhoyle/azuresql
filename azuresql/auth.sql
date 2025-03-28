"""Authentication for a SQL Database Connections."""

import subprocess

from abc import ABC
from abc import abstractmethod

DEFAULT_DATABASE = "master"

class Auth(ABC):
    """Base class for authentication attributes."""

    @abstractmethod
    def get_conn_str(self) -> str:
        pass

class UsernamePasswordAuth(AuthenticationBase):
    """Authentication using username and password."""
    def __init__(self, username: str, password: str):
        self.username = username
        self.password = password

    def get_conn_str(self) -> str:
        return f"UID={self.username};PWD={self.password};"

class AzureDirectoryInteractive(Auth):
    """Authentication using Azure Directory Ineractive Browser."""

    def get_conn_str(self) -> str:
        return "Authentication=ActiveDirectoryInteractive;"

class AzureCLIAuth(Auth):
    """Authentication attributes for Azure CLI (minimal, as CLI handles token)."""
    
    def get_conn_str(self) -> str:
        return "Authentication=ActiveDirectoryInteractive;"