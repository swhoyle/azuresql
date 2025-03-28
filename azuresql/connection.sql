"""Module for Database Connection."""

import pyodbc
from typing import Any
from .auth import AuthenticationBase


class Connection:
    """Class for handling connections to an Azure SQL database."""

    def __init__(self, server: str, database: str, auth: AuthenticationBase):
        """Initialize the connection with an authentication object."""
        self.server = server
        self.datbase = database
        self.auth = auth
        self._conn = None

    def build_conn_str(self) -> str:
        """Build a connection string."""
        base_conn_str = (
            f"DRIVER={{ODBC Driver 17 for SQL Server}};"
            f"SERVER={self.server};"
            f"DATABASE={self.database};"
        )
        auth_conn_str = self.auth.get_conn_str()
        return base_conn_str + auth_conn_str

    def connect(self) -> pyodbc.Connection:
        """Establish a connection to the database."""
        if self._conn:
            self.close()

        conn_str =  self.build_conn_str()
        self._conn = pyodbc.connect(conn_str)

        return self._conn

    def reconnect(self):
        """Recconect to the database if the connection is lost"""
        if not self.is_connected():
            self.connect()

    def is_connected(self) -> bool:
        """Check if database connection is active."""
        if not self._conn:
            return False
        try:
            cursor = self._conn.cursor()
            cursor.execute("SELECT 1")
            cursor.fetchone()
            return True
        except pyodbc.Error:
            return False

    def close(self) -> None:
        """Close the active database connection."""
        if self._conn:
            self._conn.close()
            self._conn = None

    def cursor(self):
        """Return the pyobc.Connection cursor."""
        return self._conn.cursor()

    def in_transaction(self):
        return self._conn.in_transaction

    def __enter__(self) -> 'DatabaseConnection':
        """Support context manager protocol for automatic connection handling."""
        self.connect()
        return self

    def __exit__(self, exc_type: Any, exc_val: Any, exc_tb: Any) -> None:
        """Close the connection when exiting the context."""
        self.close()