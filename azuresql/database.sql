"""Module for Azure SQL Database."""
from typing import Literal

from .connection import Connection
from .database import Database
from .auth import Auth
from .keywords import SQLKeyWords

class Database:
    """Class for an Azure SQL database."""
    
    def __init__(self, server: str, database: str, auth: Auth):
        self.server = server
        self.database = database
        self.connection = Connection(self.auth)

    def query(sql: str, return_type: Literal['cursor','raw','dict'] = 'dict'):
       """Executes a SQL SELECT query and returns the result as a dict"""
        self.connection.reconnect()
        cursor = self.connection.cursor()

        if not self._is_select_query(sql):
            raise ValueError("Only SELECT queries are allowed.")

        if return_type not in ['cursor', 'raw', 'dict']:
            raise ValueError("Invalid return_type.")

        self.connection.reconnect()
        
        cursor.execute(sql)
        return _fetch_results(cursor)

    def execute(self, query, params=None):
        """Executes a SQL query (e.g., SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER etc.)."""
        self.connection.reconnect()
        cursor = self.connection.cursor()
        self.cursor.execute(query, params)

        if not self.connection.in_transaction():
            self.cursor.commit()
        return cursor

    def _is_select_query(sql: str):
        """Check if SQL query is a SELECT query."""
        return sql.strip().upper().startswith(SQLKeyWords.SELECT)

    def _fetch_results(cursor, return_type):
        """Fetches results from a SQL query."""

        return_type_map = {
            'cursor': self._return_cursor,
            'raw': self._return_raw
            'dict': self._return_dict
        }
        
        results = return_type_map[return_type](cursor)
        
        return results

    def _return_cursor(cursor):
        """Return the cursor of the query results."""
        return cursor

    def _return_dict(self, cursor):
        """Return the query results as a dictionary."""
        columns = [column[0] for column in cursor.description]
        rows = cursor.fetchall()
        return [dict(zip(columns, row)) for row in rows]

    def _return_raw(self, rows, columns):
        """Return the raw query results."""
        return cursor.fetchall()