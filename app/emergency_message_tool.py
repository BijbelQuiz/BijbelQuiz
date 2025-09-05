#!/usr/bin/env python3
"""
Emergency Message Tool for BijbelQuiz

This tool allows administrators to send and manage emergency messages
that will be displayed to all app users.
"""

import json
import tkinter as tk
from tkinter import messagebox, scrolledtext, ttk
from typing import Any, Dict, Optional

import requests


class EmergencyMessageClient:
    """Client for interacting with the emergency message API."""
    
    def __init__(self, api_url: str, token: Optional[str] = None) -> None:
        """Initialize the emergency message client.
        
        Args:
            api_url: The URL of the emergency message API endpoint
            token: Optional authentication token for admin access
        """
        self.api_url = api_url
        self.token = token
        self.headers = {"Content-Type": "application/json"}
        if token:
            self.headers["Authorization"] = f"Bearer {token}"
    
    def set_token(self, token: str) -> None:
        """Set or update the authentication token.
        
        Args:
            token: The authentication token to set
        """
        self.token = token
        self.headers["Authorization"] = f"Bearer {token}"
    
    def send_message(self, message: str, is_blocking: bool = False) -> Dict[str, Any]:
        """Send an emergency message to the server."""
        if not self.token:
            raise ValueError("Authentication token is required")
            
        data = {
            'message': message,
            'isBlocking': is_blocking
        }
        
        response = requests.post(
            self.api_url,
            headers=self.headers,
            data=json.dumps(data)
        )
        return response.json()
    
    def clear_message(self) -> Dict[str, Any]:
        """Clear the current emergency message."""
        if not self.token:
            raise ValueError("Authentication token is required")
            
        response = requests.delete(
            self.api_url,
            headers=self.headers
        )
        return response.json()
    
    def get_message(self) -> Dict[str, Any]:
        """Get the current emergency message."""
        response = requests.get(self.api_url, headers=self.headers)
        if response.status_code == 204:
            return {}
        return response.json()


class EmergencyMessageApp:
    """Graphical user interface for the emergency message tool."""
    
    def __init__(self, root: tk.Tk) -> None:
        """Initialize the emergency message application.
        
        Args:
            root: The root Tkinter window
        """
        self.root = root
        self.root.title("BijbelQuiz Emergency Message Tool")
        self.root.geometry("600x400")
        
        self.client = EmergencyMessageClient(
            "https://bijbelquiz.app/api/emergency"
        )
        self.token = tk.StringVar()
        self.is_blocking = tk.BooleanVar(value=False)
        self.message_text: scrolledtext.ScrolledText
        self.status_var: tk.StringVar
        
        self.setup_ui()
    
    def setup_ui(self) -> None:
        """Set up the user interface."""
        # Main container
        main_frame = ttk.Frame(self.root, padding="20")
        main_frame.pack(fill=tk.BOTH, expand=True)
        
        # Token section
        ttk.Label(main_frame, text="Admin Token:").pack(anchor=tk.W, pady=(0, 5))
        token_entry = ttk.Entry(
            main_frame, 
            textvariable=self.token, 
            width=60, 
            show="*"
        )
        token_entry.pack(fill=tk.X, pady=(0, 15))
        
        # Message section
        ttk.Label(main_frame, text="Emergency Message:").pack(
            anchor=tk.W, 
            pady=(0, 5)
        )
        self.message_text = scrolledtext.ScrolledText(
            main_frame, 
            height=8, 
            wrap=tk.WORD
        )
        self.message_text.pack(fill=tk.BOTH, expand=True, pady=(0, 10))
        
        # Options
        ttk.Checkbutton(
            main_frame,
            text="Blocking (users cannot dismiss)",
            variable=self.is_blocking
        ).pack(anchor=tk.W, pady=(0, 15))
        
        # Buttons
        button_frame = ttk.Frame(main_frame)
        button_frame.pack(fill=tk.X, pady=(10, 0))
        
        ttk.Button(
            button_frame,
            text="Send Message",
            command=self.on_send_message
        ).pack(side=tk.LEFT, padx=(0, 10))
        
        ttk.Button(
            button_frame,
            text="Clear Message",
            command=self.on_clear_message
        ).pack(side=tk.LEFT, padx=10)
        
        ttk.Button(
            button_frame,
            text="Check Status",
            command=self.on_check_status
        ).pack(side=tk.LEFT, padx=10)
        
        # Status bar
        self.status_var = tk.StringVar(value="Ready")
        ttk.Label(
            main_frame,
            textvariable=self.status_var,
            relief=tk.SUNKEN,
            anchor=tk.W,
            padding=5
        ).pack(fill=tk.X, pady=(15, 0))
    
    def on_send_message(self) -> None:
        """Handle send message button click."""
        message = self.message_text.get("1.0", tk.END).strip()
        if not self.token.get():
            messagebox.showerror("Error", "Please enter an admin token")
            return
            
        if not message:
            messagebox.showerror("Error", "Please enter a message")
            return
            
        try:
            self.client.set_token(self.token.get())
            result = self.client.send_message(message, self.is_blocking.get())
            self.status_var.set(
                f"Message sent! Expires at: {result.get('expiresAt', 'N/A')}"
            )
            messagebox.showinfo("Success", "Emergency message sent successfully!")
        except Exception as e:
            messagebox.showerror("Error", f"Failed to send message: {str(e)}")
    
    def on_clear_message(self) -> None:
        """Handle clear message button click."""
        if not self.token.get():
            messagebox.showerror("Error", "Please enter an admin token")
            return
            
        try:
            self.client.set_token(self.token.get())
            result = self.client.clear_message()
            if result.get('success'):
                self.status_var.set("Message cleared successfully")
                messagebox.showinfo("Success", "Emergency message cleared!")
            else:
                raise Exception("Failed to clear message")
        except Exception as e:
            messagebox.showerror("Error", f"Failed to clear message: {str(e)}")
    
    def on_check_status(self) -> None:
        """Handle check status button click."""
        try:
            result = self.client.get_message()
            if 'message' in result:
                status = (
                    f"Current message: {result['message']}\n"
                    f"Blocking: {result.get('isBlocking', False)}\n"
                    f"Expires at: {result.get('expiresAt', 'N/A')}"
                )
                self.status_var.set("Message found")
                messagebox.showinfo("Current Status", status)
            else:
                self.status_var.set("No active message")
                messagebox.showinfo("Status", "No active emergency message")
        except Exception as e:
            messagebox.showerror("Error", f"Failed to check status: {str(e)}")


if __name__ == "__main__":
    # Create and run the application
    root = tk.Tk()
    app = EmergencyMessageApp(root)
    root.mainloop()
