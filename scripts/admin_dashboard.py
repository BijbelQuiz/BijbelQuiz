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
        self.setup_store_tab()
        self.setup_messages_tab()
        
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

    def setup_store_tab(self):
        """Setup the store items management tab"""
        # Main store frame
        store_frame = tb.Frame(self.notebook)
        self.notebook.add(store_frame, text="Store Management")
        
        # Controls and filters frame
        controls_frame = tb.Labelframe(store_frame, text="Store Controls & Filters", padding=10)
        controls_frame.pack(fill=tk.X, padx=5, pady=5)
        
        # Load data button
        tb.Button(controls_frame, text="Load Store Items", 
                 command=self.load_store_items, bootstyle=SUCCESS).pack(side=tk.LEFT, padx=5)
        
        # Add new item button
        tb.Button(controls_frame, text="Add New Item", 
                 command=self.add_new_store_item, bootstyle=INFO).pack(side=tk.LEFT, padx=5)
        
        # Filters
        tb.Label(controls_frame, text="Item Type:").pack(side=tk.LEFT, padx=(20, 5))
        self.item_type_filter = tb.Combobox(controls_frame, width=15, bootstyle="secondary", values=[
            "", "powerup", "theme", "feature"
        ])
        self.item_type_filter.pack(side=tk.LEFT, padx=5)
        self.item_type_filter.bind('<<ComboboxSelected>>', lambda e: self.load_store_items())
        
        # Search by name
        tb.Label(controls_frame, text="Search:").pack(side=tk.LEFT, padx=(10, 5))
        self.store_search = tb.Entry(controls_frame, width=15, bootstyle="secondary")
        self.store_search.pack(side=tk.LEFT, padx=5)
        self.store_search.bind('<KeyRelease>', lambda e: self.load_store_items())
        
        # Split store frame into two main sections
        store_data_frame = tb.Frame(store_frame)
        store_data_frame.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)
        
        # Left: Store items list
        left_store_frame = tb.Frame(store_data_frame)
        left_store_frame.pack(side=tk.LEFT, fill=tk.BOTH, expand=True, padx=(0, 5))
        
        # Store items list frame
        store_list_frame = tb.Labelframe(left_store_frame, text="Store Items", padding=10)
        store_list_frame.pack(fill=tk.BOTH, expand=True)
        
        # Treeview for store items
        store_tree_frame = tb.Frame(store_list_frame)
        store_tree_frame.pack(fill=tk.BOTH, expand=True)
        
        self.store_tree = tb.Treeview(store_tree_frame, 
                                    columns=('item_key', 'item_name', 'item_type', 'base_price', 'current_price', 'is_discounted'), 
                                    show='headings', height=15, bootstyle="primary")
        
        # Define headings
        self.store_tree.heading('item_key', text='Item Key')
        self.store_tree.heading('item_name', text='Name')
        self.store_tree.heading('item_type', text='Type')
        self.store_tree.heading('base_price', text='Base Price')
        self.store_tree.heading('current_price', text='Current Price')
        self.store_tree.heading('is_discounted', text='Discounted')
        
        # Define column widths
        self.store_tree.column('item_key', width=150)
        self.store_tree.column('item_name', width=200)
        self.store_tree.column('item_type', width=100)
        self.store_tree.column('base_price', width=100)
        self.store_tree.column('current_price', width=120)
        self.store_tree.column('is_discounted', width=100)
        
        # Add scrollbar
        store_v_scrollbar = tb.Scrollbar(store_tree_frame, orient=tk.VERTICAL, 
                                       command=self.store_tree.yview, bootstyle="round")
        self.store_tree.configure(yscrollcommand=store_v_scrollbar.set)
        
        self.store_tree.grid(row=0, column=0, sticky="nsew")
        store_v_scrollbar.grid(row=0, column=1, sticky="ns")
        
        store_tree_frame.grid_rowconfigure(0, weight=1)
        store_tree_frame.grid_columnconfigure(0, weight=1)
        
        # Bind selection event
        self.store_tree.bind('<<TreeviewSelect>>', self.on_store_item_select)
        
        # Right: Item details and editing
        right_store_frame = tb.Frame(store_data_frame)
        right_store_frame.pack(side=tk.RIGHT, fill=tk.BOTH, expand=True, padx=(5, 0))
        
        # Item details frame
        item_details_frame = tb.Labelframe(right_store_frame, text="Item Details", padding=10)
        item_details_frame.pack(fill=tk.BOTH, expand=True)
        
        # Create form fields for editing
        self.create_store_item_form(item_details_frame)
    
    def create_store_item_form(self, parent_frame):
        """Create form fields for store item details"""
        # Scrollable frame for the form
        canvas = tk.Canvas(parent_frame)
        scrollbar = tb.Scrollbar(parent_frame, orient="vertical", command=canvas.yview, bootstyle="round")
        scrollable_frame = tb.Frame(canvas)

        scrollable_frame.bind(
            "<Configure>",
            lambda e: canvas.configure(scrollregion=canvas.bbox("all"))
        )

        canvas.create_window((0, 0), window=scrollable_frame, anchor="nw")
        canvas.configure(yscrollcommand=scrollbar.set)

        # Form fields
        # Item Key
        tb.Label(scrollable_frame, text="Item Key:").grid(row=0, column=0, sticky="w", pady=2)
        self.item_key_var = tk.StringVar()
        self.item_key_entry = tb.Entry(scrollable_frame, textvariable=self.item_key_var, bootstyle="secondary", width=30)
        self.item_key_entry.grid(row=0, column=1, sticky="ew", pady=2, padx=(10, 0))
        self.item_key_entry.config(state="readonly")  # Read-only for existing items

        # Item Name
        tb.Label(scrollable_frame, text="Name:").grid(row=1, column=0, sticky="w", pady=2)
        self.item_name_var = tk.StringVar()
        self.item_name_entry = tb.Entry(scrollable_frame, textvariable=self.item_name_var, bootstyle="secondary", width=30)
        self.item_name_entry.grid(row=1, column=1, sticky="ew", pady=2, padx=(10, 0))

        # Item Description
        tb.Label(scrollable_frame, text="Description:").grid(row=2, column=0, sticky="w", pady=2)
        self.item_description_var = tk.StringVar()
        self.item_description_entry = tb.Entry(scrollable_frame, textvariable=self.item_description_var, bootstyle="secondary", width=30)
        self.item_description_entry.grid(row=2, column=1, sticky="ew", pady=2, padx=(10, 0))

        # Item Type
        tb.Label(scrollable_frame, text="Type:").grid(row=3, column=0, sticky="w", pady=2)
        self.item_type_var = tk.StringVar()
        self.item_type_combo = tb.Combobox(scrollable_frame, textvariable=self.item_type_var, 
                                          values=["powerup", "theme", "feature"], 
                                          state="readonly", bootstyle="secondary", width=27)
        self.item_type_combo.grid(row=3, column=1, sticky="ew", pady=2, padx=(10, 0))

        # Icon
        tb.Label(scrollable_frame, text="Icon:").grid(row=4, column=0, sticky="w", pady=2)
        self.icon_var = tk.StringVar()
        self.icon_entry = tb.Entry(scrollable_frame, textvariable=self.icon_var, bootstyle="secondary", width=30)
        self.icon_entry.grid(row=4, column=1, sticky="ew", pady=2, padx=(10, 0))

        # Base Price
        tb.Label(scrollable_frame, text="Base Price:").grid(row=5, column=0, sticky="w", pady=2)
        self.base_price_var = tk.IntVar()
        self.base_price_spinbox = tb.Spinbox(scrollable_frame, from_=0, to=9999, textvariable=self.base_price_var, bootstyle="secondary", width=28)
        self.base_price_spinbox.grid(row=5, column=1, sticky="ew", pady=2, padx=(10, 0))

        # Category
        tb.Label(scrollable_frame, text="Category:").grid(row=6, column=0, sticky="w", pady=2)
        self.category_var = tk.StringVar()
        self.category_entry = tb.Entry(scrollable_frame, textvariable=self.category_var, bootstyle="secondary", width=30)
        self.category_entry.grid(row=6, column=1, sticky="ew", pady=2, padx=(10, 0))

        # Is Active
        tb.Label(scrollable_frame, text="Is Active:").grid(row=7, column=0, sticky="w", pady=2)
        self.is_active_var = tk.BooleanVar()
        self.is_active_check = tb.Checkbutton(scrollable_frame, variable=self.is_active_var)
        self.is_active_check.grid(row=7, column=1, sticky="w", pady=2, padx=(10, 0))

        # Current Price (read-only)
        tb.Label(scrollable_frame, text="Current Price:").grid(row=8, column=0, sticky="w", pady=2)
        self.current_price_var = tk.IntVar()
        self.current_price_label = tb.Label(scrollable_frame, textvariable=self.current_price_var, bootstyle="secondary")
        self.current_price_label.grid(row=8, column=1, sticky="w", pady=2, padx=(10, 0))

        # Is Discounted
        tb.Label(scrollable_frame, text="Is Discounted:").grid(row=9, column=0, sticky="w", pady=2)
        self.is_discounted_var = tk.BooleanVar()
        self.is_discounted_check = tb.Checkbutton(scrollable_frame, variable=self.is_discounted_var, command=self.on_discount_change)
        self.is_discounted_check.grid(row=9, column=1, sticky="w", pady=2, padx=(10, 0))

        # Discount Percentage
        tb.Label(scrollable_frame, text="Discount %:").grid(row=10, column=0, sticky="w", pady=2)
        self.discount_percentage_var = tk.IntVar()
        self.discount_percentage_spinbox = tb.Spinbox(scrollable_frame, from_=0, to=100, textvariable=self.discount_percentage_var, bootstyle="secondary", width=28)
        self.discount_percentage_spinbox.grid(row=10, column=1, sticky="ew", pady=2, padx=(10, 0))

        # Discount Start Date
        tb.Label(scrollable_frame, text="Discount Start:").grid(row=11, column=0, sticky="w", pady=2)
        self.discount_start_var = tk.StringVar()
        self.discount_start_entry = tb.Entry(scrollable_frame, textvariable=self.discount_start_var, bootstyle="secondary", width=30)
        self.discount_start_entry.grid(row=11, column=1, sticky="ew", pady=2, padx=(10, 0))
        tb.Label(scrollable_frame, text="(YYYY-MM-DD HH:MM:SS format)", font=("TkDefaultFont", 8)).grid(row=11, column=2, sticky="w", pady=2)

        # Discount End Date
        tb.Label(scrollable_frame, text="Discount End:").grid(row=12, column=0, sticky="w", pady=2)
        self.discount_end_var = tk.StringVar()
        self.discount_end_entry = tb.Entry(scrollable_frame, textvariable=self.discount_end_var, bootstyle="secondary", width=30)
        self.discount_end_entry.grid(row=12, column=1, sticky="ew", pady=2, padx=(10, 0))
        tb.Label(scrollable_frame, text="(YYYY-MM-DD HH:MM:SS format)", font=("TkDefaultFont", 8)).grid(row=12, column=2, sticky="w", pady=2)

        # Button frame
        button_frame = tb.Frame(scrollable_frame)
        button_frame.grid(row=13, column=0, columnspan=2, pady=10)

        # Update button
        self.update_item_btn = tb.Button(button_frame, text="Update Item", 
                                       command=self.update_store_item, bootstyle=INFO)
        self.update_item_btn.pack(side=tk.LEFT, padx=(0, 10))

        # Delete button
        self.delete_item_btn = tb.Button(button_frame, text="Delete Item", 
                                       command=self.delete_store_item, bootstyle=DANGER)
        self.delete_item_btn.pack(side=tk.LEFT)

        # Configure grid weights
        parent_frame.grid_rowconfigure(0, weight=1)
        parent_frame.grid_columnconfigure(0, weight=1)
        scrollable_frame.grid_columnconfigure(1, weight=1)

        # Pack the canvas and scrollbar
        canvas.pack(side="left", fill="both", expand=True)
        scrollbar.pack(side="right", fill="y")
    
    def load_store_items(self, event=None):
        """Load store items from Supabase with optional filtering"""
        if not self.supabase_client:
            messagebox.showerror("Error", "Not connected to Supabase. Please check your credentials.")
            return
        
        try:
            # Build query with filters
            query = self.supabase_client.table('store_items').select('*').order('item_name')
            
            # Apply filters
            item_type = self.item_type_filter.get()
            if item_type:
                query = query.eq('item_type', item_type)
            
            search_text = self.store_search.get().strip()
            if search_text:
                query = query.ilike('item_name', f'%{search_text}%')
            
            # Execute query
            response = query.execute()
            
            # Clear existing items
            for item in self.store_tree.get_children():
                self.store_tree.delete(item)
            
            # Add new items
            for item in response.data:
                item_key = item.get('item_key', '')
                item_name = item.get('item_name', '')
                item_type = item.get('item_type', '')
                base_price = item.get('base_price', 0)
                current_price = item.get('current_price', 0)
                is_discounted = item.get('is_discounted', False)
                
                # Format discounted indicator
                discount_status = "Yes" if is_discounted else "No"
                
                self.store_tree.insert('', tk.END, values=(
                    item_key,
                    item_name,
                    item_type,
                    base_price,
                    current_price,
                    discount_status
                ), tags=(item['id'],))  # Store item ID as tag
            
            self.status_var.set(f"Loaded {len(response.data)} store items")
            
        except Exception as e:
            messagebox.showerror("Error", f"Failed to load store items: {str(e)}")
            self.status_var.set("Error loading store items")
    
    def on_store_item_select(self, event):
        """Handle store item selection in the treeview"""
        selection = self.store_tree.selection()
        if not selection:
            print("No selection made")
            return
        
        item = self.store_tree.item(selection[0])
        print(f"Selected item: {item}")
        
        # Check if tags exist and have content
        if 'tags' not in item or not item['tags']:
            print("No tags found in selected item")
            return
        
        item_id = item['tags'][0]  # Get item ID from tags
        print(f"Item ID to load: {item_id}")
        
        self.load_store_item_details(item_id)
    
    def load_store_item_details(self, item_id):
        """Load and display details of a selected store item"""
        print(f"Loading store item details for ID: {item_id}")
        
        if not self.supabase_client:
            print("No Supabase client available")
            return
        
        try:
            response = self.supabase_client.table('store_items').select('*').eq('id', item_id).execute()
            print(f"Response data: {response.data}")
            
            if not response.data:
                print(f"No data found for item ID: {item_id}")
                return
            
            store_item = response.data[0]
            print(f"Store item loaded: {store_item}")
            
            # Update form fields with item details
            self.item_key_var.set(store_item.get('item_key', ''))
            self.item_name_var.set(store_item.get('item_name', ''))
            self.item_description_var.set(store_item.get('item_description', ''))
            self.item_type_var.set(store_item.get('item_type', ''))
            self.icon_var.set(store_item.get('icon', ''))
            self.base_price_var.set(store_item.get('base_price', 0))
            self.category_var.set(store_item.get('category', ''))
            self.is_active_var.set(store_item.get('is_active', True))
            self.current_price_var.set(store_item.get('current_price', 0))
            self.is_discounted_var.set(store_item.get('is_discounted', False))
            self.discount_percentage_var.set(store_item.get('discount_percentage', 0))
            
            # Format dates for display
            discount_start = store_item.get('discount_start', '')
            if discount_start:
                # Convert ISO format to a more readable format if needed
                self.discount_start_var.set(discount_start[:19])  # Get only datetime part
            else:
                self.discount_start_var.set('')
                
            discount_end = store_item.get('discount_end', '')
            if discount_end:
                self.discount_end_var.set(discount_end[:19])  # Get only datetime part
            else:
                self.discount_end_var.set('')
                
            print("Store item details loaded successfully")
            
            # Update the UI to ensure it refreshes
            self.root.update_idletasks()
                
        except Exception as e:
            print(f"Exception in load_store_item_details: {e}")
            messagebox.showerror("Error", f"Failed to load store item details: {str(e)}")
    
    def on_discount_change(self):
        """Handle changes to discount checkbox"""
        is_discounted = self.is_discounted_var.get()
        
        # Enable/disable discount fields based on discount status
        state = 'normal' if is_discounted else 'disabled'
        self.discount_percentage_spinbox.config(state=state)
        self.discount_start_entry.config(state=state)
        self.discount_end_entry.config(state=state)
        
    def update_store_item(self):
        """Update a store item in the database"""
        if not self.supabase_client:
            messagebox.showerror("Error", "Not connected to Supabase. Please check your credentials.")
            return
        
        try:
            # Get the selected item ID
            selection = self.store_tree.selection()
            if not selection:
                messagebox.showwarning("Warning", "Please select a store item to update.")
                return
            
            item = self.store_tree.item(selection[0])
            item_id = item['tags'][0]
            
            # Prepare data to update
            update_data = {
                'item_name': self.item_name_var.get(),
                'item_description': self.item_description_var.get(),
                'item_type': self.item_type_var.get(),
                'icon': self.icon_var.get(),
                'base_price': self.base_price_var.get(),
                'category': self.category_var.get(),
                'is_active': self.is_active_var.get(),
                'is_discounted': self.is_discounted_var.get(),
                'discount_percentage': self.discount_percentage_var.get(),
            }
            
            # Handle date fields - convert empty strings to None
            discount_start = self.discount_start_var.get().strip()
            if discount_start:
                update_data['discount_start'] = discount_start
            else:
                update_data['discount_start'] = None
                
            discount_end = self.discount_end_var.get().strip()
            if discount_end:
                update_data['discount_end'] = discount_end
            else:
                update_data['discount_end'] = None
            
            # Update the item in the database
            response = self.supabase_client.table('store_items').update(update_data).eq('id', item_id).execute()
            
            if response:
                messagebox.showinfo("Success", "Store item updated successfully.")
                self.load_store_items()  # Refresh the list
            else:
                messagebox.showerror("Error", "Failed to update store item.")
                
        except Exception as e:
            messagebox.showerror("Error", f"Failed to update store item: {str(e)}")
    
    def delete_store_item(self):
        """Delete a store item from the database"""
        if not self.supabase_client:
            messagebox.showerror("Error", "Not connected to Supabase. Please check your credentials.")
            return
        
        try:
            # Get the selected item ID
            selection = self.store_tree.selection()
            if not selection:
                messagebox.showwarning("Warning", "Please select a store item to delete.")
                return
            
            item = self.store_tree.item(selection[0])
            item_id = item['tags'][0]
            
            # Confirm deletion with the user
            result = messagebox.askyesno("Confirm Deletion", 
                                      f"Are you sure you want to delete store item with ID: {item_id}?\n\nThis action cannot be undone.")
            
            if result:
                # Delete the item from the database
                response = self.supabase_client.table('store_items').delete().eq('id', item_id).execute()
                
                if response:
                    messagebox.showinfo("Success", "Store item deleted successfully.")
                    self.load_store_items()  # Refresh the list
                else:
                    messagebox.showerror("Error", "Failed to delete store item.")
                    
        except Exception as e:
            messagebox.showerror("Error", f"Failed to delete store item: {str(e)}")
    
    def add_new_store_item(self):
        """Add a new store item to the database"""
        if not self.supabase_client:
            messagebox.showerror("Error", "Not connected to Supabase. Please check your credentials.")
            return
        
        # Create a new window for adding a store item
        add_window = tk.Toplevel(self.root)
        add_window.title("Add New Store Item")
        add_window.geometry("400x500")
        
        # Create form fields for new item
        frame = tb.Frame(add_window, padding=20)
        frame.pack(fill=tk.BOTH, expand=True)
        
        # Item Key
        tb.Label(frame, text="Item Key:").grid(row=0, column=0, sticky="w", pady=2)
        item_key_var = tk.StringVar()
        tb.Entry(frame, textvariable=item_key_var, bootstyle="secondary").grid(row=0, column=1, sticky="ew", pady=2, padx=(10, 0))
        
        # Item Name
        tb.Label(frame, text="Name:").grid(row=1, column=0, sticky="w", pady=2)
        item_name_var = tk.StringVar()
        tb.Entry(frame, textvariable=item_name_var, bootstyle="secondary").grid(row=1, column=1, sticky="ew", pady=2, padx=(10, 0))
        
        # Item Description
        tb.Label(frame, text="Description:").grid(row=2, column=0, sticky="w", pady=2)
        item_description_var = tk.StringVar()
        tb.Entry(frame, textvariable=item_description_var, bootstyle="secondary").grid(row=2, column=1, sticky="ew", pady=2, padx=(10, 0))
        
        # Item Type
        tb.Label(frame, text="Type:").grid(row=3, column=0, sticky="w", pady=2)
        item_type_var = tk.StringVar()
        tb.Combobox(frame, textvariable=item_type_var, 
                   values=["powerup", "theme", "feature"], 
                   state="readonly", bootstyle="secondary").grid(row=3, column=1, sticky="ew", pady=2, padx=(10, 0))
        
        # Icon
        tb.Label(frame, text="Icon:").grid(row=4, column=0, sticky="w", pady=2)
        icon_var = tk.StringVar()
        tb.Entry(frame, textvariable=icon_var, bootstyle="secondary").grid(row=4, column=1, sticky="ew", pady=2, padx=(10, 0))
        
        # Base Price
        tb.Label(frame, text="Base Price:").grid(row=5, column=0, sticky="w", pady=2)
        base_price_var = tk.IntVar()
        tb.Spinbox(frame, from_=0, to=9999, textvariable=base_price_var, bootstyle="secondary").grid(row=5, column=1, sticky="ew", pady=2, padx=(10, 0))
        
        # Category
        tb.Label(frame, text="Category:").grid(row=6, column=0, sticky="w", pady=2)
        category_var = tk.StringVar()
        tb.Entry(frame, textvariable=category_var, bootstyle="secondary").grid(row=6, column=1, sticky="ew", pady=2, padx=(10, 0))
        
        # Is Active
        tb.Label(frame, text="Is Active:").grid(row=7, column=0, sticky="w", pady=2)
        is_active_var = tk.BooleanVar(value=True)
        tb.Checkbutton(frame, variable=is_active_var).grid(row=7, column=1, sticky="w", pady=2, padx=(10, 0))
        
        # Is Discounted
        tb.Label(frame, text="Is Discounted:").grid(row=8, column=0, sticky="w", pady=2)
        is_discounted_var = tk.BooleanVar()
        discount_check = tb.Checkbutton(frame, variable=is_discounted_var)
        discount_check.grid(row=8, column=1, sticky="w", pady=2, padx=(10, 0))
        
        # Discount Percentage
        tb.Label(frame, text="Discount %:").grid(row=9, column=0, sticky="w", pady=2)
        discount_percentage_var = tk.IntVar()
        discount_perc_spinbox = tb.Spinbox(frame, from_=0, to=100, textvariable=discount_percentage_var, bootstyle="secondary")
        discount_perc_spinbox.grid(row=9, column=1, sticky="ew", pady=2, padx=(10, 0))
        discount_perc_spinbox.config(state="disabled")
        
        # Bind discount checkbox to enable/disable discount fields
        def toggle_discount_fields():
            state = 'normal' if is_discounted_var.get() else 'disabled'
            discount_perc_spinbox.config(state=state)
        
        discount_check.config(command=toggle_discount_fields)
        
        # Category grid configuration
        frame.grid_columnconfigure(1, weight=1)
        
        # Buttons
        button_frame = tb.Frame(frame)
        button_frame.grid(row=10, column=0, columnspan=2, pady=20)
        
        def save_new_item():
            try:
                # Validate required fields
                if not item_key_var.get().strip():
                    messagebox.showerror("Error", "Item Key is required.")
                    return
                if not item_name_var.get().strip():
                    messagebox.showerror("Error", "Item Name is required.")
                    return
                
                # Prepare data
                new_item_data = {
                    'item_key': item_key_var.get().strip(),
                    'item_name': item_name_var.get().strip(),
                    'item_description': item_description_var.get().strip(),
                    'item_type': item_type_var.get(),
                    'icon': icon_var.get().strip(),
                    'base_price': base_price_var.get(),
                    'category': category_var.get().strip(),
                    'is_active': is_active_var.get(),
                    'is_discounted': is_discounted_var.get(),
                    'discount_percentage': discount_percentage_var.get(),
                }
                
                # Insert the new item into the database
                response = self.supabase_client.table('store_items').insert(new_item_data).execute()
                
                if response:
                    messagebox.showinfo("Success", "Store item added successfully.")
                    add_window.destroy()
                    self.load_store_items()  # Refresh the list
                else:
                    messagebox.showerror("Error", "Failed to add store item.")
                    
            except Exception as e:
                messagebox.showerror("Error", f"Failed to add store item: {str(e)}")
        
        tb.Button(button_frame, text="Save", command=save_new_item, bootstyle=SUCCESS).pack(side=tk.LEFT, padx=(0, 10))
        tb.Button(button_frame, text="Cancel", command=add_window.destroy, bootstyle=SECONDARY).pack(side=tk.LEFT)

    def setup_messages_tab(self):
        """Setup the messages management tab"""
        # Main message frame
        message_frame = tb.Frame(self.notebook)
        self.notebook.add(message_frame, text="Message Management")
        
        # Controls and filters frame
        controls_frame = tb.Labelframe(message_frame, text="Message Controls & Filters", padding=10)
        controls_frame.pack(fill=tk.X, padx=5, pady=5)
        
        # Load data button
        tb.Button(controls_frame, text="Load Messages", 
                 command=self.load_messages, bootstyle=SUCCESS).pack(side=tk.LEFT, padx=5)
        
        # Add new message button
        tb.Button(controls_frame, text="Add New Message", 
                 command=self.add_new_message, bootstyle=INFO).pack(side=tk.LEFT, padx=5)
        
        # Search by title
        tb.Label(controls_frame, text="Search:").pack(side=tk.LEFT, padx=(20, 5))
        self.message_search = tb.Entry(controls_frame, width=15, bootstyle="secondary")
        self.message_search.pack(side=tk.LEFT, padx=5)
        self.message_search.bind('<KeyRelease>', lambda e: self.load_messages())
        
        # Split message frame into two main sections
        message_data_frame = tb.Frame(message_frame)
        message_data_frame.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)
        
        # Left: Messages list
        left_message_frame = tb.Frame(message_data_frame)
        left_message_frame.pack(side=tk.LEFT, fill=tk.BOTH, expand=True, padx=(0, 5))
        
        # Messages list frame
        message_list_frame = tb.Labelframe(left_message_frame, text="Messages", padding=10)
        message_list_frame.pack(fill=tk.BOTH, expand=True)
        
        # Treeview for messages
        message_tree_frame = tb.Frame(message_list_frame)
        message_tree_frame.pack(fill=tk.BOTH, expand=True)
        
        self.message_tree = tb.Treeview(message_tree_frame, 
                                      columns=('id', 'title', 'content', 'expiration_date', 'created_at'), 
                                      show='headings', height=15, bootstyle="primary")
        
        # Define headings
        self.message_tree.heading('id', text='ID')
        self.message_tree.heading('title', text='Title')
        self.message_tree.heading('content', text='Content')
        self.message_tree.heading('expiration_date', text='Expiration Date')
        self.message_tree.heading('created_at', text='Created At')
        
        # Define column widths
        self.message_tree.column('id', width=80)
        self.message_tree.column('title', width=150)
        self.message_tree.column('content', width=200)
        self.message_tree.column('expiration_date', width=150)
        self.message_tree.column('created_at', width=150)
        
        # Add scrollbar
        message_v_scrollbar = tb.Scrollbar(message_tree_frame, orient=tk.VERTICAL, 
                                         command=self.message_tree.yview, bootstyle="round")
        self.message_tree.configure(yscrollcommand=message_v_scrollbar.set)
        
        self.message_tree.grid(row=0, column=0, sticky="nsew")
        message_v_scrollbar.grid(row=0, column=1, sticky="ns")
        
        message_tree_frame.grid_rowconfigure(0, weight=1)
        message_tree_frame.grid_columnconfigure(0, weight=1)
        
        # Bind selection event
        self.message_tree.bind('<<TreeviewSelect>>', self.on_message_select)
        
        # Right: Message details and editing
        right_message_frame = tb.Frame(message_data_frame)
        right_message_frame.pack(side=tk.RIGHT, fill=tk.BOTH, expand=True, padx=(5, 0))
        
        # Message details frame
        message_details_frame = tb.Labelframe(right_message_frame, text="Message Details", padding=10)
        message_details_frame.pack(fill=tk.BOTH, expand=True)
        
        # Create form fields for editing
        self.create_message_form(message_details_frame)
    
    def create_message_form(self, parent_frame):
        """Create form fields for message details"""
        # Scrollable frame for the form
        canvas = tk.Canvas(parent_frame)
        scrollbar = tb.Scrollbar(parent_frame, orient="vertical", command=canvas.yview, bootstyle="round")
        scrollable_frame = tb.Frame(canvas)

        scrollable_frame.bind(
            "<Configure>",
            lambda e: canvas.configure(scrollregion=canvas.bbox("all"))
        )

        canvas.create_window((0, 0), window=scrollable_frame, anchor="nw")
        canvas.configure(yscrollcommand=scrollbar.set)

        # Form fields
        # ID (read-only)
        tb.Label(scrollable_frame, text="ID:").grid(row=0, column=0, sticky="w", pady=2)
        self.message_id_var = tk.StringVar()
        self.message_id_label = tb.Label(scrollable_frame, textvariable=self.message_id_var, bootstyle="secondary")
        self.message_id_label.grid(row=0, column=1, sticky="w", pady=2, padx=(10, 0))

        # Title
        tb.Label(scrollable_frame, text="Title:").grid(row=1, column=0, sticky="w", pady=2)
        self.message_title_var = tk.StringVar()
        self.message_title_entry = tb.Entry(scrollable_frame, textvariable=self.message_title_var, bootstyle="secondary", width=30)
        self.message_title_entry.grid(row=1, column=1, sticky="ew", pady=2, padx=(10, 0))

        # Content
        tb.Label(scrollable_frame, text="Content:").grid(row=2, column=0, sticky="w", pady=2)
        self.message_content_var = tk.StringVar()
        self.message_content_entry = tb.Entry(scrollable_frame, textvariable=self.message_content_var, bootstyle="secondary", width=30)
        self.message_content_entry.grid(row=2, column=1, sticky="ew", pady=2, padx=(10, 0))

        # Expiration Date
        tb.Label(scrollable_frame, text="Expiration Date:").grid(row=3, column=0, sticky="w", pady=2)
        self.expiration_date_var = tk.StringVar()
        self.expiration_date_entry = tb.Entry(scrollable_frame, textvariable=self.expiration_date_var, bootstyle="secondary", width=30)
        self.expiration_date_entry.grid(row=3, column=1, sticky="ew", pady=2, padx=(10, 0))
        tb.Label(scrollable_frame, text="(YYYY-MM-DD HH:MM:SS format)", font=("TkDefaultFont", 8)).grid(row=3, column=2, sticky="w", pady=2)

        # Created At (read-only)
        tb.Label(scrollable_frame, text="Created At:").grid(row=4, column=0, sticky="w", pady=2)
        self.created_at_var = tk.StringVar()
        self.created_at_label = tb.Label(scrollable_frame, textvariable=self.created_at_var, bootstyle="secondary")
        self.created_at_label.grid(row=4, column=1, sticky="w", pady=2, padx=(10, 0))

        # Button frame
        button_frame = tb.Frame(scrollable_frame)
        button_frame.grid(row=5, column=0, columnspan=2, pady=10)

        # Update button
        self.update_message_btn = tb.Button(button_frame, text="Update Message", 
                                          command=self.update_message, bootstyle=INFO)
        self.update_message_btn.pack(side=tk.LEFT, padx=(0, 10))

        # Delete button
        self.delete_message_btn = tb.Button(button_frame, text="Delete Message", 
                                          command=self.delete_message, bootstyle=DANGER)
        self.delete_message_btn.pack(side=tk.LEFT)

        # Configure grid weights
        parent_frame.grid_rowconfigure(0, weight=1)
        parent_frame.grid_columnconfigure(0, weight=1)
        scrollable_frame.grid_columnconfigure(1, weight=1)

        # Pack the canvas and scrollbar
        canvas.pack(side="left", fill="both", expand=True)
        scrollbar.pack(side="right", fill="y")
    
    def load_messages(self, event=None):
        """Load messages from Supabase with optional filtering"""
        if not self.supabase_client:
            messagebox.showerror("Error", "Not connected to Supabase. Please check your credentials.")
            return
        
        try:
            # Build query with filters
            query = self.supabase_client.table('messages').select('*').order('created_at', desc=True)
            
            search_text = self.message_search.get().strip()
            if search_text:
                query = query.ilike('title', f'%{search_text}%').or_(query.ilike('content', f'%{search_text}%'))
            
            # Execute query
            response = query.execute()
            
            # Clear existing messages
            for item in self.message_tree.get_children():
                self.message_tree.delete(item)
            
            # Add new messages
            for message in response.data:
                message_id = message.get('id', '')
                title = message.get('title', '')
                content = message.get('content', '')
                expiration_date = message.get('expiration_date', '')
                created_at = message.get('created_at', '')
                
                # Truncate content if too long
                if len(content) > 50:
                    content = content[:50] + "..."
                
                self.message_tree.insert('', tk.END, values=(
                    message_id,
                    title,
                    content,
                    expiration_date,
                    created_at
                ), tags=(message['id'],))  # Store message ID as tag
            
            self.status_var.set(f"Loaded {len(response.data)} messages")
            
        except Exception as e:
            messagebox.showerror("Error", f"Failed to load messages: {str(e)}")
            self.status_var.set("Error loading messages")
    
    def on_message_select(self, event):
        """Handle message selection in the treeview"""
        selection = self.message_tree.selection()
        if not selection:
            return
        
        item = self.message_tree.item(selection[0])
        message_id = item['tags'][0]  # Get message ID from tags
        
        self.load_message_details(message_id)
    
    def load_message_details(self, message_id):
        """Load and display details of a selected message"""
        if not self.supabase_client:
            return
        
        try:
            response = self.supabase_client.table('messages').select('*').eq('id', message_id).execute()
            if not response.data:
                messagebox.showinfo("Info", "Message not found")
                return
            
            message = response.data[0]
            
            # Update form fields with message details
            self.message_id_var.set(message.get('id', ''))
            self.message_title_var.set(message.get('title', ''))
            self.message_content_var.set(message.get('content', ''))
            
            # Format dates for display
            expiration_date = message.get('expiration_date', '')
            if expiration_date:
                # Convert ISO format to a more readable format if needed
                self.expiration_date_var.set(expiration_date[:19])  # Get only datetime part
            else:
                self.expiration_date_var.set('')
                
            created_at = message.get('created_at', '')
            if created_at:
                self.created_at_var.set(created_at[:19])  # Get only datetime part
            else:
                self.created_at_var.set('')
            
            # Update the UI to ensure it refreshes
            self.root.update_idletasks()
                
        except Exception as e:
            messagebox.showerror("Error", f"Failed to load message details: {str(e)}")
    
    def update_message(self):
        """Update a message in the database"""
        if not self.supabase_client:
            messagebox.showerror("Error", "Not connected to Supabase. Please check your credentials.")
            return
        
        try:
            # Get the selected message ID
            selection = self.message_tree.selection()
            if not selection:
                messagebox.showwarning("Warning", "Please select a message to update.")
                return
            
            item = self.message_tree.item(selection[0])
            message_id = item['tags'][0]
            
            # Prepare data to update
            update_data = {
                'title': self.message_title_var.get().strip(),
                'content': self.message_content_var.get().strip(),
                'expiration_date': self.expiration_date_var.get().strip(),
            }
            
            # Validate required fields
            if not update_data['title']:
                messagebox.showerror("Error", "Message title is required.")
                return
            if not update_data['content']:
                messagebox.showerror("Error", "Message content is required.")
                return
            if not update_data['expiration_date']:
                messagebox.showerror("Error", "Expiration date is required (format: YYYY-MM-DD HH:MM:SS).")
                return
            
            # Update the message in the database
            response = self.supabase_client.table('messages').update(update_data).eq('id', message_id).execute()
            
            if response:
                messagebox.showinfo("Success", "Message updated successfully.")
                self.load_messages()  # Refresh the list
            else:
                messagebox.showerror("Error", "Failed to update message.")
                
        except Exception as e:
            messagebox.showerror("Error", f"Failed to update message: {str(e)}")
    
    def delete_message(self):
        """Delete a message from the database"""
        if not self.supabase_client:
            messagebox.showerror("Error", "Not connected to Supabase. Please check your credentials.")
            return
        
        try:
            # Get the selected message ID
            selection = self.message_tree.selection()
            if not selection:
                messagebox.showwarning("Warning", "Please select a message to delete.")
                return
            
            item = self.message_tree.item(selection[0])
            message_id = item['tags'][0]
            
            # Confirm deletion with the user
            result = messagebox.askyesno("Confirm Deletion", 
                                      f"Are you sure you want to delete message with ID: {message_id}?\n\nThis action cannot be undone.")
            
            if result:
                # Delete the message from the database
                response = self.supabase_client.table('messages').delete().eq('id', message_id).execute()
                
                if response:
                    messagebox.showinfo("Success", "Message deleted successfully.")
                    self.load_messages()  # Refresh the list
                else:
                    messagebox.showerror("Error", "Failed to delete message.")
                    
        except Exception as e:
            messagebox.showerror("Error", f"Failed to delete message: {str(e)}")
    
    def add_new_message(self):
        """Add a new message to the database"""
        if not self.supabase_client:
            messagebox.showerror("Error", "Not connected to Supabase. Please check your credentials.")
            return
        
        # Create a new window for adding a message
        add_window = tk.Toplevel(self.root)
        add_window.title("Add New Message")
        add_window.geometry("400x300")
        
        # Create form fields for new message
        frame = tb.Frame(add_window, padding=20)
        frame.pack(fill=tk.BOTH, expand=True)
        
        # Title
        tb.Label(frame, text="Title:").grid(row=0, column=0, sticky="w", pady=2)
        title_var = tk.StringVar()
        tb.Entry(frame, textvariable=title_var, bootstyle="secondary", width=30).grid(row=0, column=1, sticky="ew", pady=2, padx=(10, 0))
        
        # Content
        tb.Label(frame, text="Content:").grid(row=1, column=0, sticky="w", pady=2)
        content_var = tk.StringVar()
        tb.Entry(frame, textvariable=content_var, bootstyle="secondary", width=30).grid(row=1, column=1, sticky="ew", pady=2, padx=(10, 0))
        
        # Expiration Date
        tb.Label(frame, text="Expiration Date:").grid(row=2, column=0, sticky="w", pady=2)
        expiration_date_var = tk.StringVar()
        tb.Entry(frame, textvariable=expiration_date_var, bootstyle="secondary", width=30).grid(row=2, column=1, sticky="ew", pady=2, padx=(10, 0))
        tb.Label(frame, text="(YYYY-MM-DD HH:MM:SS format)", font=("TkDefaultFont", 8)).grid(row=2, column=2, sticky="w", pady=2)
        
        # Category grid configuration
        frame.grid_columnconfigure(1, weight=1)
        
        # Buttons
        button_frame = tb.Frame(frame)
        button_frame.grid(row=3, column=0, columnspan=2, pady=20)
        
        def save_new_message():
            try:
                # Validate required fields
                title = title_var.get().strip()
                content = content_var.get().strip()
                expiration_date = expiration_date_var.get().strip()
                
                if not title:
                    messagebox.showerror("Error", "Message title is required.")
                    return
                if not content:
                    messagebox.showerror("Error", "Message content is required.")
                    return
                if not expiration_date:
                    messagebox.showerror("Error", "Expiration date is required (format: YYYY-MM-DD HH:MM:SS).")
                    return
                
                # Prepare data
                new_message_data = {
                    'title': title,
                    'content': content,
                    'expiration_date': expiration_date,
                    'created_at': datetime.now().isoformat(),  # Set current time
                }
                
                # Insert the new message into the database
                response = self.supabase_client.table('messages').insert(new_message_data).execute()
                
                if response:
                    messagebox.showinfo("Success", "Message added successfully.")
                    add_window.destroy()
                    self.load_messages()  # Refresh the list
                else:
                    messagebox.showerror("Error", "Failed to add message.")
                    
            except Exception as e:
                messagebox.showerror("Error", f"Failed to add message: {str(e)}")
        
        tb.Button(button_frame, text="Save", command=save_new_message, bootstyle=SUCCESS).pack(side=tk.LEFT, padx=(0, 10))
        tb.Button(button_frame, text="Cancel", command=add_window.destroy, bootstyle=SECONDARY).pack(side=tk.LEFT)
    



def main():
    root = tb.Window(themename="superhero")
    app = ModernAdminDashboard(root)
    root.mainloop()


if __name__ == "__main__":
    main()