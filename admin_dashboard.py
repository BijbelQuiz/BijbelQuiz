"""
Modern Admin Dashboard for BijbelQuiz
Combines tracking data analysis and error reporting in a single modern interface
"""
import tkinter as tk
from tkinter import ttk, scrolledtext, messagebox
import ttkbootstrap as tb
from ttkbootstrap.constants import *
import json
import pandas as pd
from datetime import datetime, timedelta
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
from supabase import create_client, Client
import os
from dotenv import load_dotenv
from dateutil import parser
import re
from typing import List, Dict, Any, Optional


class ModernAdminDashboard:
    def __init__(self, root):
        self.root = root
        
        # Use ttkbootstrap style
        self.root = tb.Window(themename="morph")
        self.root.title("BijbelQuiz Modern Admin Dashboard")
        self.root.geometry("1400x900")
        
        # Initialize Supabase client
        self.supabase_client = None
        self.initialize_supabase()
        
        # Data
        self.df = None
        self.current_error_id = None
        
        self.setup_ui()
    
    def initialize_supabase(self):
        """Initialize Supabase client using environment variables"""
        try:
            # Load environment variables
            load_dotenv()
            
            url = os.getenv('SUPABASE_URL')
            key = os.getenv('SUPABASE_SERVICE_ROLE_KEY')  # Should use service role key for admin access
            
            if not url or not key:
                messagebox.showerror("Error", "Supabase credentials not found in environment variables.\n\nPlease set SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY in your .env file.")
                return
            
            self.supabase_client = create_client(url, key)
            # Test connection
            self.test_connection()
        except Exception as e:
            messagebox.showerror("Error", f"Failed to connect to Supabase: {str(e)}")
            self.supabase_client = None
    
    def test_connection(self):
        """Test the Supabase connection"""
        try:
            # Try to fetch a small sample to test connection
            response = self.supabase_client.table('tracking_events').select('id').limit(1).execute()
            print("Supabase connection successful")
        except Exception as e:
            messagebox.showerror("Connection Error", f"Could not connect to Supabase: {str(e)}")
            self.supabase_client = None
    
    def setup_ui(self):
        """Set up the user interface with modern design"""
        # Create main container
        main_frame = tb.Frame(self.root)
        main_frame.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)
        
        # Create header frame with gradient-like effect using ttkbootstrap
        header_frame = tb.Frame(main_frame, bootstyle="primary")
        header_frame.pack(fill=tk.X, pady=(0, 10))
        
        tb.Label(
            header_frame, 
            text="  BijbelQuiz Admin Dashboard", 
            font=("TkDefaultFont", 24, "bold"),
            bootstyle="inverse-light"
        ).pack(side=tk.LEFT, padx=10, pady=10)
        
        # Add a separator
        separator = tb.Separator(main_frame, bootstyle="primary")
        separator.pack(fill=tk.X, pady=(0, 10))
        
        # Create notebook for different sections
        self.notebook = tb.Notebook(main_frame)
        self.notebook.pack(fill=tk.BOTH, expand=True, pady=(0, 10))
        
        # Add tabs
        self.setup_tracking_tab()
        self.setup_errors_tab()
        
        # Initially show tracking tab
        self.notebook.select(0)
        
        # Create status bar
        self.status_var = tk.StringVar()
        self.status_var.set("Ready")
        status_bar = tb.Label(main_frame, textvariable=self.status_var, bootstyle=INFO)
        status_bar.pack(fill=tk.X, pady=(0, 0))
    
    def setup_tracking_tab(self):
        """Setup the tracking data analysis tab"""
        # Main tracking frame
        tracking_frame = tb.Frame(self.notebook)
        self.notebook.add(tracking_frame, text="Tracking Data")
        
        # Controls frame
        controls_frame = tb.Labelframe(tracking_frame, text="Data Controls", padding=10)
        controls_frame.pack(fill=tk.X, padx=5, pady=5)
        
        # Load data button
        tb.Button(controls_frame, text="Load Tracking Data", 
                 command=self.load_tracking_data, bootstyle=SUCCESS).pack(side=tk.LEFT, padx=5)
        
        # Filter options
        tb.Label(controls_frame, text="Feature:").pack(side=tk.LEFT, padx=(20, 5))
        self.feature_var = tk.StringVar()
        self.feature_combo = tb.Combobox(controls_frame, textvariable=self.feature_var, 
                                        state="readonly", width=15, bootstyle="secondary")
        self.feature_combo.pack(side=tk.LEFT, padx=5)
        
        tb.Label(controls_frame, text="Action:").pack(side=tk.LEFT, padx=(10, 5))
        self.action_var = tk.StringVar()
        self.action_combo = tb.Combobox(controls_frame, textvariable=self.action_var, 
                                       state="readonly", width=15, bootstyle="secondary")
        self.action_combo.pack(side=tk.LEFT, padx=5)
        
        tb.Label(controls_frame, text="Date From:").pack(side=tk.LEFT, padx=(10, 5))
        self.date_from_var = tk.StringVar()
        date_from_entry = tb.Entry(controls_frame, textvariable=self.date_from_var, width=12, bootstyle="secondary")
        date_from_entry.pack(side=tk.LEFT, padx=5)
        
        tb.Label(controls_frame, text="Date To:").pack(side=tk.LEFT, padx=(10, 5))
        self.date_to_var = tk.StringVar()
        date_to_entry = tb.Entry(controls_frame, textvariable=self.date_to_var, width=12, bootstyle="secondary")
        date_to_entry.pack(side=tk.LEFT, padx=5)
        
        tb.Button(controls_frame, text="Apply Filters", 
                 command=self.apply_tracking_filters, bootstyle=INFO).pack(side=tk.LEFT, padx=(20, 5))
        
        # Split tracking frame into two main sections
        data_frame = tb.Frame(tracking_frame)
        data_frame.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)
        
        # Left side: Features overview
        left_frame = tb.Frame(data_frame)
        left_frame.pack(side=tk.LEFT, fill=tk.BOTH, expand=True, padx=(0, 5))
        
        # Features overview display
        features_frame = tb.Labelframe(left_frame, text="All Features Overview", padding=10)
        features_frame.pack(fill=tk.BOTH, expand=True)
        
        # Treeview for features
        features_tree_frame = tb.Frame(features_frame)
        features_tree_frame.pack(fill=tk.BOTH, expand=True)
        
        self.features_tree = tb.Treeview(features_tree_frame, 
                                        columns=("Feature", "UsageCount", "UniqueUsers", "LastUsed"), 
                                        show="headings", height=15, bootstyle="primary")
        
        # Configure columns
        self.features_tree.heading("Feature", text="Feature")
        self.features_tree.heading("UsageCount", text="Total Usage")
        self.features_tree.heading("UniqueUsers", text="Unique Users")
        self.features_tree.heading("LastUsed", text="Last Used")
        
        # Set column widths
        self.features_tree.column("Feature", width=200, minwidth=150)
        self.features_tree.column("UsageCount", width=100, minwidth=80)
        self.features_tree.column("UniqueUsers", width=100, minwidth=80)
        self.features_tree.column("LastUsed", width=150, minwidth=120)
        
        # Scrollbars
        v_scrollbar = tb.Scrollbar(features_tree_frame, orient="vertical", command=self.features_tree.yview, bootstyle="round")
        h_scrollbar = tb.Scrollbar(features_tree_frame, orient="horizontal", command=self.features_tree.xview, bootstyle="round")
        
        self.features_tree.configure(yscrollcommand=v_scrollbar.set, xscrollcommand=h_scrollbar.set)
        
        self.features_tree.grid(row=0, column=0, sticky="nsew")
        v_scrollbar.grid(row=0, column=1, sticky="ns")
        h_scrollbar.grid(row=1, column=0, sticky="ew")
        
        features_tree_frame.grid_rowconfigure(0, weight=1)
        features_tree_frame.grid_columnconfigure(0, weight=1)
        
        # Bind selection event for features
        self.features_tree.bind("<<TreeviewSelect>>", self.on_feature_select)
        
        # Create the old treeview (for backward compatibility with some methods)
        # This will be hidden but still available for methods that reference it
        old_tree_frame = tb.Frame(features_frame)
        old_tree_frame.pack(fill=tk.BOTH, expand=False)  # Don't expand to make it invisible
        
        self.tree = tb.Treeview(old_tree_frame,
                               columns=("ID", "UserID", "EventType", "EventName", "Properties", "Timestamp"),
                               show="headings", height=0, bootstyle="primary")  # Height of 0 makes it invisible

        # Right side: Analysis and details
        right_frame = tb.Frame(data_frame)
        right_frame.pack(side=tk.RIGHT, fill=tk.BOTH, expand=True, padx=(5, 0))
        
        # Details panel
        details_frame = tb.Labelframe(right_frame, text="Feature Details", padding=10)
        details_frame.pack(fill=tk.BOTH, expand=True, pady=(0, 10))
        
        self.details_text = scrolledtext.ScrolledText(details_frame, height=8, wrap=tk.WORD)
        self.details_text.pack(fill=tk.BOTH, expand=True)
        
        # Analysis panel
        analysis_frame = tb.Labelframe(right_frame, text="Feature Usage Breakdown", padding=10)
        analysis_frame.pack(fill=tk.BOTH, expand=True)
        
        # Analysis controls
        analysis_controls = tb.Frame(analysis_frame)
        analysis_controls.pack(fill=tk.X, pady=(0, 10))
        
        tb.Button(analysis_controls, text="Analyze Feature", 
                 command=self.analyze_feature_usage, bootstyle=INFO).pack(side=tk.LEFT, padx=5)
        
        # Stats display
        self.stats_text = scrolledtext.ScrolledText(analysis_frame, height=8)
        self.stats_text.pack(fill=tk.BOTH, expand=True)
        
        # Frame for visualization (graphs) - initially hidden
        # Create a main container for the visualization with scrolling capability
        viz_container = tb.Frame(right_frame)
        viz_container.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)
        
        # Create a canvas and scrollbar for scrolling
        self.viz_canvas = tk.Canvas(viz_container, bg='white')
        self.viz_scrollbar = tb.Scrollbar(viz_container, orient="vertical", command=self.viz_canvas.yview, bootstyle="round")
        
        # Create the visualization frame inside the canvas
        self.viz_frame = tb.Labelframe(self.viz_canvas, text="Feature Usage Visualization", padding=10)
        
        # Configure the scrolling
        self.viz_frame.bind(
            "<Configure>",
            lambda e: self.viz_canvas.configure(scrollregion=self.viz_canvas.bbox("all"))
        )
        
        # Create a window inside the canvas to hold the visualization frame
        self.viz_canvas.create_window((0, 0), window=self.viz_frame, anchor="nw")
        self.viz_canvas.configure(yscrollcommand=self.viz_scrollbar.set)
        
        # Bind mousewheel to canvas for scrolling
        def _on_mousewheel(event):
            self.viz_canvas.yview_scroll(int(-1*(event.delta/120)), "units")
        
        self.viz_canvas.bind("<MouseWheel>", _on_mousewheel)
    
    def setup_errors_tab(self):
        """Setup the error reporting tab"""
        # Main error frame
        error_frame = tb.Frame(self.notebook)
        self.notebook.add(error_frame, text="Error Reports")
        
        # Controls and filters frame
        controls_frame = tb.Labelframe(error_frame, text="Error Controls & Filters", padding=10)
        controls_frame.pack(fill=tk.X, padx=5, pady=5)
        
        # Refresh button
        tb.Button(controls_frame, text="Load Error Reports", 
                 command=self.load_error_reports, bootstyle=SUCCESS).pack(side=tk.LEFT, padx=5)
        
        tb.Button(controls_frame, text="Clear Filters", 
                 command=self.clear_error_filters, bootstyle=SECONDARY).pack(side=tk.LEFT, padx=5)
        
        # Delete button
        tb.Button(controls_frame, text="Delete Selected Error", 
                 command=self.delete_selected_error, bootstyle=DANGER).pack(side=tk.LEFT, padx=5)
        
        # Filters
        tb.Label(controls_frame, text="Error Type:").pack(side=tk.LEFT, padx=(20, 5))
        self.error_type_filter = tb.Combobox(controls_frame, width=20, bootstyle="secondary", values=[
            "", "AppErrorType.network", "AppErrorType.dataLoading", "AppErrorType.authentication",
            "AppErrorType.permission", "AppErrorType.validation", "AppErrorType.payment",
            "AppErrorType.ai", "AppErrorType.api", "AppErrorType.storage", "AppErrorType.sync", 
            "AppErrorType.unknown"
        ])
        self.error_type_filter.pack(side=tk.LEFT, padx=5)
        self.error_type_filter.bind('<<ComboboxSelected>>', lambda e: self.load_error_reports())
        
        tb.Label(controls_frame, text="User ID:").pack(side=tk.LEFT, padx=(10, 5))
        self.user_filter = tb.Entry(controls_frame, width=15, bootstyle="secondary")
        self.user_filter.pack(side=tk.LEFT, padx=5)
        self.user_filter.bind('<KeyRelease>', lambda e: self.load_error_reports())
        
        tb.Label(controls_frame, text="Question ID:").pack(side=tk.LEFT, padx=(10, 5))
        self.question_filter = tb.Entry(controls_frame, width=15, bootstyle="secondary")
        self.question_filter.pack(side=tk.LEFT, padx=5)
        self.question_filter.bind('<KeyRelease>', lambda e: self.load_error_reports())
        
        # Split error frame into two main sections
        error_data_frame = tb.Frame(error_frame)
        error_data_frame.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)
        
        # Left: Error list
        left_error_frame = tb.Frame(error_data_frame)
        left_error_frame.pack(side=tk.LEFT, fill=tk.BOTH, expand=True, padx=(0, 5))
        
        # Error list frame
        error_list_frame = tb.Labelframe(left_error_frame, text="Error Reports", padding=10)
        error_list_frame.pack(fill=tk.BOTH, expand=True)
        
        # Treeview for errors
        error_tree_frame = tb.Frame(error_list_frame)
        error_tree_frame.pack(fill=tk.BOTH, expand=True)
        
        self.error_tree = tb.Treeview(error_tree_frame, 
                                    columns=('timestamp', 'type', 'user_id', 'question_id', 'error_msg'), 
                                    show='headings', height=20, bootstyle="primary")
        
        # Configure the row height to show more text
        self.error_tree.configure(height=20)  # Increase the number of visible rows
        
        # Configure row height to accommodate more text
        self.error_tree.column("#0", width=0, stretch=False)  # Hide the first column
        style = ttk.Style()
        style.configure("Treeview", rowheight=60)  # Set row height to accommodate more text
        
        # Define headings
        self.error_tree.heading('timestamp', text='Timestamp')
        self.error_tree.heading('type', text='Type')
        self.error_tree.heading('user_id', text='User ID')
        self.error_tree.heading('question_id', text='Question ID')
        self.error_tree.heading('error_msg', text='Error Message')
        
        # Define column widths
        self.error_tree.column('timestamp', width=150)
        self.error_tree.column('type', width=120)
        self.error_tree.column('user_id', width=100)
        self.error_tree.column('question_id', width=80)
        self.error_tree.column('error_msg', width=500)
        
        # Add scrollbar
        error_v_scrollbar = tb.Scrollbar(error_tree_frame, orient=tk.VERTICAL, 
                                       command=self.error_tree.yview, bootstyle="round")
        self.error_tree.configure(yscrollcommand=error_v_scrollbar.set)
        
        self.error_tree.grid(row=0, column=0, sticky="nsew")
        error_v_scrollbar.grid(row=0, column=1, sticky="ns")
        
        error_tree_frame.grid_rowconfigure(0, weight=1)
        error_tree_frame.grid_columnconfigure(0, weight=1)
        
        # Bind selection event
        self.error_tree.bind('<<TreeviewSelect>>', self.on_error_select)
        
        # Bind mouse hover event to show full error message
        self.error_tree.bind('<Motion>', self.on_error_hover)
        
        # Right: Error details
        right_error_frame = tb.Frame(error_data_frame)
        right_error_frame.pack(side=tk.RIGHT, fill=tk.BOTH, expand=True, padx=(5, 0))
        
        # Error details frame
        error_details_frame = tb.Labelframe(right_error_frame, text="Error Details", padding=10)
        error_details_frame.pack(fill=tk.BOTH, expand=True)
        
        self.error_details_text = scrolledtext.ScrolledText(error_details_frame, wrap=tk.WORD, font=("TkDefaultFont", 10))
        self.error_details_text.pack(fill=tk.BOTH, expand=True)
    
    def load_tracking_data(self):
        """Load tracking data from Supabase"""
        if not self.supabase_client:
            messagebox.showerror("Error", "Not connected to Supabase. Please check your credentials.")
            return
        
        try:
            # Load data from Supabase
            response = self.supabase_client.table('tracking_events').select('*').order('timestamp', desc=True).execute()
            
            # Convert to DataFrame
            self.df = pd.DataFrame(response.data)
            
            if self.df.empty:
                messagebox.showinfo("Info", "No tracking data found in Supabase")
                return
            
            # Format timestamp
            self.df['timestamp'] = pd.to_datetime(self.df['timestamp'])
            
            # Update filter options
            self.update_tracking_filter_options()
            
            # Display records - this will update both the old records view and the new features overview
            self.display_tracking_records()
            self.display_features_overview()
            
            self.status_var.set(f"Loaded {len(self.df)} tracking records from Supabase")
            
        except Exception as e:
            messagebox.showerror("Error", f"Failed to load data from Supabase: {str(e)}")
    
    def load_error_reports(self, event=None):
        """Load error reports from Supabase with optional filtering"""
        if not self.supabase_client:
            messagebox.showerror("Error", "Not connected to Supabase. Please check your credentials.")
            return
        
        try:
            # Build query with filters
            query = self.supabase_client.table('error_reports').select('*').order('timestamp', desc=True)
            
            # Apply filters
            error_type = self.error_type_filter.get()
            if error_type:
                query = query.eq('error_type', error_type)
            
            user_id = self.user_filter.get().strip()
            if user_id:
                query = query.eq('user_id', user_id)
            
            question_id = self.question_filter.get().strip()
            if question_id:
                query = query.eq('question_id', question_id)
            
            # Execute query
            response = query.execute()
            
            # Clear existing items
            for item in self.error_tree.get_children():
                self.error_tree.delete(item)
            
            # Add new items
            for error in response.data:
                timestamp = error.get('timestamp', '')[:19]  # Get only the datetime part
                error_type = error.get('error_type', '')
                user_id = error.get('user_id', '')
                question_id = error.get('question_id', '')
                error_msg = error.get('user_message', '') or error.get('error_message', '')
                
                # Truncate error message if too long
                if len(error_msg) > 150:
                    error_msg = error_msg[:150] + "..."
                
                self.error_tree.insert('', tk.END, values=(
                    timestamp,
                    error_type,
                    user_id,
                    question_id,
                    error_msg
                ), tags=(error['id'],))  # Store error ID as tag
            
            self.status_var.set(f"Loaded {len(response.data)} error reports")
            
        except Exception as e:
            messagebox.showerror("Error", f"Failed to load error reports: {str(e)}")
            self.status_var.set("Error loading error reports")
    
    def update_tracking_filter_options(self):
        """Update filter options based on loaded data"""
        if self.df is None or self.df.empty:
            return
        
        # Update feature combo
        features = sorted(self.df['event_name'].dropna().unique())
        self.feature_combo['values'] = ['All'] + list(features)
        self.feature_combo.set('All')
        
        # Update action combo
        actions = sorted(self.df['event_type'].dropna().unique())
        self.action_combo['values'] = ['All'] + list(actions)
        self.action_combo.set('All')
    
    def display_features_overview(self):
        """Display features overview in the treeview"""
        # Clear existing records
        for item in self.features_tree.get_children():
            self.features_tree.delete(item)
        
        if self.df is None or self.df.empty:
            return
        
        # Get filtered data for overview
        filtered_df = self.get_filtered_tracking_data()
        
        # Group by features and calculate statistics
        feature_stats = filtered_df.groupby('event_name').agg({
            'id': 'count',  # Total usage count
            'user_id': 'nunique',  # Unique users
            'timestamp': 'max'  # Last used
        }).reset_index()
        
        # Rename columns for clarity
        feature_stats.columns = ['Feature', 'UsageCount', 'UniqueUsers', 'LastUsed']
        
        # Insert records into features tree
        for _, row in feature_stats.iterrows():
            values = [
                row['Feature'],
                row['UsageCount'],
                row['UniqueUsers'],
                row['LastUsed'].strftime('%Y-%m-%d %H:%M:%S') if pd.notna(row['LastUsed']) else 'N/A'
            ]
            
            self.features_tree.insert('', 'end', values=values)
    
    def display_tracking_records(self):
        """Display detailed tracking records in the old records treeview"""
        # Clear existing records in the old treeview (for backwards compatibility)
        for item in self.tree.get_children():
            self.tree.delete(item)
        
        # Get filtered data
        filtered_df = self.get_filtered_tracking_data()
        
        # Insert records
        for _, row in filtered_df.iterrows():
            # Format properties for display (truncate if too long)
            props_str = str(row.get('properties', ''))
            if len(props_str) > 100:
                props_str = props_str[:100] + "..."
                
            values = [
                row.get('id', ''),
                row.get('user_id', ''),
                row.get('event_type', ''),
                row.get('event_name', ''),
                props_str,
                row.get('timestamp', '')
            ]
            
            self.tree.insert('', 'end', values=values)
    
    def get_filtered_tracking_data(self):
        """Get tracking data based on current filters"""
        if self.df is None or self.df.empty:
            return pd.DataFrame()
        
        filtered_df = self.df.copy()
        
        # Apply feature filter
        feature = self.feature_var.get()
        if feature and feature != 'All':
            filtered_df = filtered_df[filtered_df['event_name'] == feature]
        
        # Apply action filter
        action = self.action_var.get()
        if action and action != 'All':
            filtered_df = filtered_df[filtered_df['event_type'] == action]
        
        # Apply date filter
        date_from = self.date_from_var.get()
        if date_from:
            try:
                date_from_dt = datetime.strptime(date_from, '%Y-%m-%d')
                filtered_df = filtered_df[filtered_df['timestamp'] >= date_from_dt]
            except ValueError:
                pass
        
        date_to = self.date_to_var.get()
        if date_to:
            try:
                date_to_dt = datetime.strptime(date_to, '%Y-%m-%d')
                filtered_df = filtered_df[filtered_df['timestamp'] <= date_to_dt]
            except ValueError:
                pass
        
        return filtered_df
    
    def apply_tracking_filters(self):
        """Apply filters to tracking data"""
        self.display_tracking_records()
        self.display_features_overview()
    
    def on_feature_select(self, event):
        """Handle feature selection in the features treeview"""
        selection = self.features_tree.selection()
        if not selection:
            return
        
        item = self.features_tree.item(selection[0])
        feature_name = item['values'][0]  # Feature name is in the first column
        
        if self.df is None or self.df.empty:
            return
        
        # Filter for the selected feature
        feature_df = self.df[self.df['event_name'] == feature_name]
        
        if feature_df.empty:
            self.details_text.delete(1.0, tk.END)
            self.details_text.insert(tk.END, f"No detailed data found for feature: {feature_name}")
            return
        
        # Display simplified detailed information about this feature
        details = f"Feature: {feature_name}\n"
        details += f"Total Usage: {len(feature_df)} events\n"
        details += f"Unique Users: {feature_df['user_id'].nunique()}\n"
        details += f"Date Range: {feature_df['timestamp'].min()} to {feature_df['timestamp'].max()}\n"
        details += f"First Used: {feature_df['timestamp'].min()}\n"
        details += f"Last Used: {feature_df['timestamp'].max()}\n"
        
        self.details_text.delete(1.0, tk.END)
        self.details_text.insert(tk.END, details)
        
        # Update the stats text with breakdown and detailed records
        stats = []
        stats.append(f"Feature: {feature_name}")
        stats.append(f"Total Events: {len(feature_df)}")
        stats.append(f"Unique Users: {feature_df['user_id'].nunique()}")
        stats.append(f"Date Range: {feature_df['timestamp'].min()} to {feature_df['timestamp'].max()}")
        
        # Actions breakdown
        action_counts = feature_df['event_type'].value_counts()
        stats.append("\nEvent Type Breakdown:")
        for action, count in action_counts.items():
            stats.append(f"  {action}: {count}")
        
        # Daily usage pattern
        daily_usage = feature_df.groupby(feature_df['timestamp'].dt.date).size()
        if len(daily_usage) > 1:
            stats.append(f"\nDaily Average: {daily_usage.mean():.2f} events per day")
            stats.append(f"Peak Day: {daily_usage.idxmax()} with {daily_usage.max()} events")
        
        # Platform breakdown
        platform_counts = feature_df['platform'].value_counts()
        stats.append("\nPlatform Breakdown:")
        for platform, count in platform_counts.items():
            if pd.notna(platform):  # Skip NaN values
                stats.append(f"  {platform}: {count}")
        
        # App version breakdown
        version_counts = feature_df['app_version'].value_counts()
        stats.append("\nApp Version Breakdown:")
        for version, count in version_counts.items():
            if pd.notna(version):  # Skip NaN values
                stats.append(f"  {version}: {count}")
        
        # Add exact records to the breakdown
        stats.append(f"\nExact Records ({len(feature_df)} total):")
        stats.append("-" * 30)
        
        # Add all records with their details
        for idx, (_, row) in enumerate(feature_df.iterrows()):
            stats.append(f"Record #{idx + 1}:")
            stats.append(f"  ID: {row.get('id', 'N/A')}")
            stats.append(f"  User ID: {row.get('user_id', 'N/A')}")
            stats.append(f"  Event Type: {row.get('event_type', 'N/A')}")
            stats.append(f"  Properties: {json.dumps(json.loads(row.get('properties', '{}')), indent=2) if row.get('properties') else '{}'}")
            stats.append(f"  Timestamp: {row.get('timestamp', 'N/A')}")
            stats.append(f"  Screen Name: {row.get('screen_name', 'N/A')}")
            stats.append(f"  Session ID: {row.get('session_id', 'N/A')}")
            stats.append(f"  Device Info: {row.get('device_info', 'N/A')}")
            stats.append(f"  App Version: {row.get('app_version', 'N/A')}")
            stats.append(f"  Build Number: {row.get('build_number', 'N/A')}")
            stats.append(f"  Platform: {row.get('platform', 'N/A')}")
            stats.append("")
        
        # Display statistics and exact records
        self.stats_text.delete(1.0, tk.END)
        self.stats_text.insert(tk.END, "\n".join(stats))
        
        # Automatically generate and show visualization for the selected feature
        self.visualize_feature_usage_for_feature(feature_name)
    
    def on_tracking_record_select(self, event):
        """Handle tracking record selection"""
        selection = self.tree.selection()
        if not selection:
            return
        
        item = self.tree.item(selection[0])
        values = item['values']
        
        # Find the corresponding record in the dataframe
        if self.df is not None and not self.df.empty:
            # Get the index based on the selected record
            try:
                record_id = values[0]  # Assuming first column is ID
                record = self.df[self.df['id'] == record_id].iloc[0]
                
                # Display detailed information
                details = f"ID: {record.get('id', 'N/A')}\n"
                details += f"User ID: {record.get('user_id', 'N/A')}\n"
                details += f"Event Type: {record.get('event_type', 'N/A')}\n"
                details += f"Event Name: {record.get('event_name', 'N/A')}\n"
                details += f"Properties: {json.dumps(json.loads(record.get('properties', '{}')), indent=2) if record.get('properties') else '{}'}\n"
                details += f"Timestamp: {record.get('timestamp', 'N/A')}\n"
                details += f"Screen Name: {record.get('screen_name', 'N/A')}\n"
                details += f"Session ID: {record.get('session_id', 'N/A')}\n"
                details += f"Device Info: {record.get('device_info', 'N/A')}\n"
                details += f"App Version: {record.get('app_version', 'N/A')}\n"
                details += f"Build Number: {record.get('build_number', 'N/A')}\n"
                details += f"Platform: {record.get('platform', 'N/A')}\n"
                
                self.details_text.delete(1.0, tk.END)
                self.details_text.insert(tk.END, details)
            except Exception as e:
                print(f"Error showing record details: {e}")
                pass  # Handle case where record isn't found
    
    def analyze_feature_usage(self):
        """Analyze usage of selected feature"""
        if self.df is None or self.df.empty:
            return
        
        # First try to get the feature from features_tree (new interface)
        selected_feature_item = self.features_tree.selection()
        
        # If no selection in features_tree, try the old tree
        if not selected_feature_item:
            selected_item = self.tree.selection()
            if not selected_item:
                messagebox.showwarning("Warning", "Please select a feature from the overview or a tracking record to analyze")
                return
        
            # Get the feature name from the selected record in old tree
            item = self.tree.item(selected_item[0])
            feature_name = item['values'][3]  # Event name is in the 4th column
        else:
            # Get the feature name from the selected item in features tree
            item = self.features_tree.item(selected_feature_item[0])
            feature_name = item['values'][0]  # Feature name is in the first column
        
        if not feature_name or feature_name == 'All':
            messagebox.showwarning("Warning", "No feature selected for analysis")
            return
        
        # Filter for the selected feature
        feature_df = self.df[self.df['event_name'] == feature_name]
        
        if feature_df.empty:
            self.stats_text.delete(1.0, tk.END)
            self.stats_text.insert(tk.END, f"No data found for feature: {feature_name}")
            return
        
        # Calculate statistics
        stats = []
        stats.append(f"Feature: {feature_name}")
        stats.append(f"Total Events: {len(feature_df)}")
        stats.append(f"Unique Users: {feature_df['user_id'].nunique()}")
        stats.append(f"Date Range: {feature_df['timestamp'].min()} to {feature_df['timestamp'].max()}")
        
        # Actions breakdown
        action_counts = feature_df['event_type'].value_counts()
        stats.append("\nEvent Type Breakdown:")
        for action, count in action_counts.items():
            stats.append(f"  {action}: {count}")
        
        # Daily usage pattern
        daily_usage = feature_df.groupby(feature_df['timestamp'].dt.date).size()
        if len(daily_usage) > 1:
            stats.append(f"\nDaily Average: {daily_usage.mean():.2f} events per day")
            stats.append(f"Peak Day: {daily_usage.idxmax()} with {daily_usage.max()} events")
        
        # Platform breakdown
        platform_counts = feature_df['platform'].value_counts()
        stats.append("\nPlatform Breakdown:")
        for platform, count in platform_counts.items():
            if pd.notna(platform):  # Skip NaN values
                stats.append(f"  {platform}: {count}")
        
        # App version breakdown
        version_counts = feature_df['app_version'].value_counts()
        stats.append("\nApp Version Breakdown:")
        for version, count in version_counts.items():
            if pd.notna(version):  # Skip NaN values
                stats.append(f"  {version}: {count}")
        
        # Display statistics
        self.stats_text.delete(1.0, tk.END)
        self.stats_text.insert(tk.END, "\n".join(stats))
    
    def visualize_feature_usage(self):
        """Visualize feature usage with matplotlib"""
        if self.df is None or self.df.empty:
            return
        
        # First try to get the feature from features_tree (new interface)
        selected_feature_item = self.features_tree.selection()
        
        # If no selection in features_tree, try the old tree
        if not selected_feature_item:
            selected_item = self.tree.selection()
            if not selected_item:
                messagebox.showwarning("Warning", "Please select a feature from the overview or a tracking record to visualize")
                return
        
            # Get the feature name from the selected record in old tree
            item = self.tree.item(selected_item[0])
            feature_name = item['values'][3]  # Event name is in the 4th column
        else:
            # Get the feature name from the selected item in features tree
            item = self.features_tree.item(selected_feature_item[0])
            feature_name = item['values'][0]  # Feature name is in the first column
        
        if not feature_name or feature_name == 'All':
            messagebox.showwarning("Warning", "No feature selected for visualization")
            return
        
        # Call the visualization method for the specified feature
        self.visualize_feature_usage_for_feature(feature_name)

    def visualize_feature_usage_for_feature(self, feature_name):
        """Visualize feature usage for a specific feature"""
        if self.df is None or self.df.empty:
            return

        # Filter for the selected feature
        feature_df = self.df[self.df['event_name'] == feature_name]
        
        if feature_df.empty:
            return  # Don't show visualization if there's no data
        
        # Clear any existing visualization
        for widget in self.viz_frame.winfo_children():
            widget.destroy()
        
        # Calculate the number of subplots to determine figure size
        n_plots = 4
        fig, axes = plt.subplots(n_plots, 1, figsize=(10, 4*n_plots))
        fig.suptitle(f'Feature Usage Analysis: {feature_name}', fontsize=14)
        
        # Make sure axes is always a list, even if there's only one subplot
        if n_plots == 1:
            axes = [axes]
        
        # Plot 1: Event types over time
        event_counts = feature_df.groupby([feature_df['timestamp'].dt.date, 'event_type']).size().unstack(fill_value=0)
        if not event_counts.empty:
            event_counts.plot(kind='bar', ax=axes[0], width=0.8)
            axes[0].set_title('Event Types Over Time')
            axes[0].set_xlabel('Date')
            axes[0].set_ylabel('Event Count')
            axes[0].tick_params(axis='x', rotation=45)
        else:
            axes[0].text(0.5, 0.5, 'No data available', horizontalalignment='center', 
                          verticalalignment='center', transform=axes[0].transAxes)
            axes[0].set_title('Event Types Over Time')
        
        # Plot 2: Platform distribution
        platform_counts = feature_df['platform'].value_counts()
        if not platform_counts.empty and len(platform_counts) > 0:
            axes[1].pie(platform_counts.values, labels=platform_counts.index, autopct='%1.1f%%')
            axes[1].set_title('Platform Distribution')
        else:
            axes[1].text(0.5, 0.5, 'No platform data', horizontalalignment='center', 
                          verticalalignment='center', transform=axes[1].transAxes)
            axes[1].set_title('Platform Distribution')
        
        # Plot 3: Daily activity pattern
        daily_counts = feature_df.groupby(feature_df['timestamp'].dt.date).size()
        if not daily_counts.empty:
            axes[2].plot(daily_counts.index, daily_counts.values, marker='o')
            axes[2].set_title('Daily Activity Trend')
            axes[2].set_xlabel('Date')
            axes[2].set_ylabel('Event Count')
            axes[2].tick_params(axis='x', rotation=45)
        else:
            axes[2].text(0.5, 0.5, 'No daily data', horizontalalignment='center', 
                          verticalalignment='center', transform=axes[2].transAxes)
            axes[2].set_title('Daily Activity Trend')
        
        # Plot 4: App version distribution
        version_counts = feature_df['app_version'].value_counts()
        if not version_counts.empty and len(version_counts) > 0:
            axes[3].bar(version_counts.index, version_counts.values)
            axes[3].set_title('App Version Distribution')
            axes[3].set_xlabel('App Version')
            axes[3].set_ylabel('Event Count')
            axes[3].tick_params(axis='x', rotation=45)
        else:
            axes[3].text(0.5, 0.5, 'No version data', horizontalalignment='center', 
                          verticalalignment='center', transform=axes[3].transAxes)
            axes[3].set_title('App Version Distribution')
        
        # Adjust layout to prevent overlap
        plt.tight_layout()
        
        # Embed the plot in the dashboard frame
        figure_canvas = FigureCanvasTkAgg(fig, master=self.viz_frame)
        figure_canvas.draw()
        figure_canvas.get_tk_widget().pack(fill=tk.BOTH, expand=True)
        
        # Store reference to canvas to prevent garbage collection
        self.canvas = figure_canvas
        
        # Update the scroll region to include all content
        self.viz_frame.update_idletasks()
        self.viz_canvas.configure(scrollregion=self.viz_canvas.bbox("all"))
        
        # Pack the canvas and scrollbar (only if not already packed)
        if not self.viz_canvas.winfo_ismapped():
            self.viz_canvas.pack(side="left", fill="both", expand=True)
        if not self.viz_scrollbar.winfo_ismapped():
            self.viz_scrollbar.pack(side="right", fill="y")
    
    def on_error_select(self, event):
        """Handle error selection in the treeview"""
        selection = self.error_tree.selection()
        if not selection:
            return
        
        item = self.error_tree.item(selection[0])
        error_id = item['tags'][0]  # Get error ID from tags
        
        self.current_error_id = error_id
        self.show_error_details(error_id)
    
    def show_error_details(self, error_id):
        """Show detailed information for a selected error"""
        if not self.supabase_client:
            return
        
        try:
            response = self.supabase_client.table('error_reports').select('*').eq('id', error_id).execute()
            if not response.data:
                self.error_details_text.delete(1.0, tk.END)
                self.error_details_text.insert(tk.END, "Error not found")
                return
            
            error = response.data[0]
            
            # Clear text widget
            self.error_details_text.delete(1.0, tk.END)
            
            # Format and display error details
            details = f"""ERROR DETAILS

ID: {error.get('id', '')}
Timestamp: {error.get('timestamp', '')}
Error Type: {error.get('error_type', '')}
User ID: {error.get('user_id', 'N/A')}
Question ID: {error.get('question_id', 'N/A')}

ERROR INFORMATION
Technical Message: {error.get('error_message', '')}
User Message: {error.get('user_message', '')}
Error Code: {error.get('error_code', 'N/A')}

CONTEXT INFORMATION
Context: {error.get('context', 'N/A')}
Additional Info: {error.get('additional_info', 'N/A')}
Stack Trace: {error.get('stack_trace', 'N/A')}

APP INFORMATION
Device Info: {error.get('device_info', 'N/A')}
App Version: {error.get('app_version', 'N/A')}
Build Number: {error.get('build_number', 'N/A')}

"""
            
            # Add tags for different sections to enable styling
            self.error_details_text.tag_configure("header", font=("TkDefaultFont", 11, "bold"))
            self.error_details_text.tag_configure("section", font=("TkDefaultFont", 10, "bold"), foreground="blue")
            
            # Insert the details
            self.error_details_text.insert(tk.END, details)
            
            # Apply tags to highlight headers and sections
            self.error_details_text.tag_add("header", "1.0", "1.13")  # ERROR DETAILS header
            self.error_details_text.tag_add("section", "7.0", "7.17")  # ERROR INFORMATION
            self.error_details_text.tag_add("section", "11.0", "11.18")  # CONTEXT INFORMATION
            self.error_details_text.tag_add("section", "15.0", "15.14")  # APP INFORMATION
            
            self.error_details_text.insert(tk.END, details)
            
        except Exception as e:
            self.error_details_text.delete(1.0, tk.END)
            self.error_details_text.insert(tk.END, f"Error loading details: {str(e)}")
    
    def on_error_hover(self, event):
        """Show full error message when hovering over error message column"""
        # Get the item at the current mouse position
        item_id = self.error_tree.identify_row(event.y)
        column = self.error_tree.identify_column(event.x)
        
        # Check if the hover is over the error message column (index 4)
        if item_id and column == "#4":  # error_msg column (0-indexed as 4, but 1-indexed as #5)
            # Get the full error message from the treeview item
            item_values = self.error_tree.item(item_id, 'values')
            
            # Only show if we're over the error message column
            if len(item_values) > 4:  # Ensure the error message exists
                error_msg = item_values[4]  # The error message
                
                # Get the actual full error message from the original data
                # This requires us to store the full message when loading errors
                # For now, we can only show the truncated message in the tooltip
                tw = tk.Toplevel()
                tw.wm_overrideredirect(True)
                tw.wm_geometry(f"+{event.x_root + 10}+{event.y_root + 10}")
                label = tk.Label(tw, text=error_msg, justify='left',
                                background="#ffffe0", relief='solid', borderwidth=1,
                                font=("TkDefaultFont", 10))
                label.pack(ipadx=1)
                
                def hide_tooltip(event):
                    tw.destroy()
                
                # Hide tooltip when mouse leaves the error_tree
                self.error_tree.bind('<Leave>', hide_tooltip)
                
    def clear_error_filters(self):
        """Clear all error filters and reload all errors"""
        self.error_type_filter.set('')
        self.user_filter.delete(0, tk.END)
        self.question_filter.delete(0, tk.END)
        self.load_error_reports()
    
    def delete_selected_error(self):
        """Delete the currently selected error report from the database"""
        if not self.supabase_client:
            messagebox.showerror("Error", "Not connected to Supabase. Please check your credentials.")
            return
        
        # Check if an error is selected
        selection = self.error_tree.selection()
        if not selection:
            messagebox.showwarning("Warning", "Please select an error report to delete.")
            return
        
        # Get the error ID from the selected item
        item = self.error_tree.item(selection[0])
        error_id = item['tags'][0]  # Get error ID from tags
        
        # Confirm deletion with the user
        result = messagebox.askyesno("Confirm Deletion", 
                                  f"Are you sure you want to delete error report with ID: {error_id}?\n\nThis action cannot be undone.")
        
        if result:
            try:
                # Delete the error from the database
                response = self.supabase_client.table('error_reports').delete().eq('id', error_id).execute()
                
                if response:
                    # Show success message
                    messagebox.showinfo("Success", f"Error report with ID {error_id} has been deleted successfully.")
                    
                    # Update status
                    self.status_var.set(f"Deleted error report with ID: {error_id}")
                    
                    # Reload the error reports to reflect the deletion
                    self.load_error_reports()
                    
            except Exception as e:
                messagebox.showerror("Error", f"Failed to delete error report: {str(e)}")
    



def main():
    root = tb.Window(themename="superhero")
    app = ModernAdminDashboard(root)
    root.mainloop()


if __name__ == "__main__":
    main()