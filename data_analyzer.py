import tkinter as tk
from tkinter import ttk, scrolledtext, messagebox
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

class TrackingDataAnalyzer:
    def __init__(self, root):
        self.root = root
        self.root.title("BijbelQuiz Tracking Data Analyzer")
        self.root.geometry("1400x900")
        
        # Set up styling
        self.style = ttk.Style()
        self.style.theme_use('clam')
        
        # Initialize Supabase client
        self.supabase_client = None
        self.initialize_supabase()
        
        # Main frame
        main_frame = ttk.Frame(root)
        main_frame.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)
        
        # Notebook for different views
        self.notebook = ttk.Notebook(main_frame)
        self.notebook.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)
        
        # Individual records tab
        self.setup_individual_records_tab()
        
        # Feature usage tab
        self.setup_feature_usage_tab()
        
        # Data
        self.df = None

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
        
    def setup_individual_records_tab(self):
        # Individual records frame
        records_frame = ttk.Frame(self.notebook)
        self.notebook.add(records_frame, text="Individual Records")
        
        # Control and filter frame
        control_frame = ttk.LabelFrame(records_frame, text="Controls & Filters", padding=10)
        control_frame.pack(fill=tk.X, padx=5, pady=5)
        
        # Refresh button
        ttk.Button(control_frame, text="Load Data", command=self.load_data).pack(side=tk.LEFT, padx=5)
        
        # Filter options
        ttk.Label(control_frame, text="Feature:").pack(side=tk.LEFT, padx=(20, 5))
        self.feature_var = tk.StringVar()
        self.feature_combo = ttk.Combobox(control_frame, textvariable=self.feature_var, state="readonly", width=20)
        self.feature_combo.pack(side=tk.LEFT, padx=5)
        
        ttk.Label(control_frame, text="Action:").pack(side=tk.LEFT, padx=(10, 5))
        self.action_var = tk.StringVar()
        self.action_combo = ttk.Combobox(control_frame, textvariable=self.action_var, state="readonly", width=20)
        self.action_combo.pack(side=tk.LEFT, padx=5)
        
        ttk.Label(control_frame, text="Date From:").pack(side=tk.LEFT, padx=(10, 5))
        self.date_from_var = tk.StringVar()
        date_from_entry = ttk.Entry(control_frame, textvariable=self.date_from_var, width=12)
        date_from_entry.pack(side=tk.LEFT, padx=5)
        
        ttk.Label(control_frame, text="Date To:").pack(side=tk.LEFT, padx=(10, 5))
        self.date_to_var = tk.StringVar()
        date_to_entry = ttk.Entry(control_frame, textvariable=self.date_to_var, width=12)
        date_to_entry.pack(side=tk.LEFT, padx=5)
        
        ttk.Button(control_frame, text="Apply Filters", command=self.apply_filters).pack(side=tk.LEFT, padx=(20, 5))
        
        # Records display
        records_display_frame = ttk.Frame(records_frame)
        records_display_frame.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)
        
        # Treeview for records
        tree_frame = ttk.Frame(records_display_frame)
        tree_frame.pack(fill=tk.BOTH, expand=True)
        
        self.tree = ttk.Treeview(tree_frame, columns=(
            "ID", "UserID", "EventType", "EventName", "Properties", "Timestamp", "ScreenName", 
            "SessionID", "DeviceInfo", "AppVersion", "BuildNumber", "Platform"
        ), show="headings", height=15)
        
        # Configure columns
        for col in self.tree["columns"]:
            self.tree.heading(col, text=col)
            self.tree.column(col, width=100, minwidth=80)
        
        # Scrollbars
        v_scrollbar = ttk.Scrollbar(tree_frame, orient="vertical", command=self.tree.yview)
        h_scrollbar = ttk.Scrollbar(tree_frame, orient="horizontal", command=self.tree.xview)
        
        self.tree.configure(yscrollcommand=v_scrollbar.set, xscrollcommand=h_scrollbar.set)
        
        self.tree.grid(row=0, column=0, sticky="nsew")
        v_scrollbar.grid(row=0, column=1, sticky="ns")
        h_scrollbar.grid(row=1, column=0, sticky="ew")
        
        tree_frame.grid_rowconfigure(0, weight=1)
        tree_frame.grid_columnconfigure(0, weight=1)
        
        # Bind selection event
        self.tree.bind("<<TreeviewSelect>>", self.on_record_select)
        
        # Details panel
        details_frame = ttk.LabelFrame(records_display_frame, text="Record Details", padding=10)
        details_frame.pack(fill=tk.X, padx=5, pady=5)
        
        self.details_text = scrolledtext.ScrolledText(details_frame, height=8)
        self.details_text.pack(fill=tk.BOTH, expand=True)
        
    def setup_feature_usage_tab(self):
        # Feature usage frame
        feature_frame = ttk.Frame(self.notebook)
        self.notebook.add(feature_frame, text="Feature Usage Analysis")
        
        # Feature selection
        feature_select_frame = ttk.Frame(feature_frame)
        feature_select_frame.pack(fill=tk.X, padx=5, pady=5)
        
        # Refresh button
        ttk.Button(feature_select_frame, text="Load Data", command=self.load_data).pack(side=tk.LEFT, padx=5)
        
        ttk.Label(feature_select_frame, text="Feature:").pack(side=tk.LEFT, padx=(20, 5))
        self.analysis_feature_var = tk.StringVar()
        self.analysis_feature_combo = ttk.Combobox(
            feature_select_frame, textvariable=self.analysis_feature_var, state="readonly", width=30
        )
        self.analysis_feature_combo.pack(side=tk.LEFT, padx=5)
        self.analysis_feature_combo.bind("<<ComboboxSelected>>", self.on_feature_change)
        
        ttk.Button(
            feature_select_frame, text="Analyze Feature", 
            command=self.analyze_feature_usage
        ).pack(side=tk.LEFT, padx=10)
        
        ttk.Button(
            feature_select_frame, text="Visualize Data", 
            command=self.visualize_feature_usage
        ).pack(side=tk.LEFT, padx=5)
        
        # Feature usage display
        usage_display_frame = ttk.Frame(feature_frame)
        usage_display_frame.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)
        
        # Stats frame
        stats_frame = ttk.LabelFrame(usage_display_frame, text="Statistics", padding=10)
        stats_frame.pack(fill=tk.X, padx=5, pady=5)
        
        self.stats_text = scrolledtext.ScrolledText(stats_frame, height=8)
        self.stats_text.pack(fill=tk.BOTH, expand=True)
        
        # Visualization frame
        self.viz_frame = ttk.Frame(usage_display_frame)
        self.viz_frame.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)
        
    def load_data(self):
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
            self.update_filter_options()
            
            # Display records
            self.display_records()
            
            messagebox.showinfo("Success", f"Loaded {len(self.df)} tracking records from Supabase")
            
        except Exception as e:
            messagebox.showerror("Error", f"Failed to load data from Supabase: {str(e)}")
    
    def update_filter_options(self):
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
        
        # Update analysis feature combo
        self.analysis_feature_combo['values'] = ['All'] + list(features)
        self.analysis_feature_combo.set('All')
    
    def display_records(self):
        # Clear existing records
        for item in self.tree.get_children():
            self.tree.delete(item)
        
        # Get filtered data
        filtered_df = self.get_filtered_data()
        
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
                row.get('timestamp', ''),
                row.get('screen_name', ''),
                row.get('session_id', ''),
                row.get('device_info', ''),
                row.get('app_version', ''),
                row.get('build_number', ''),
                row.get('platform', '')
            ]
            
            self.tree.insert('', 'end', values=values)
    
    def get_filtered_data(self):
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
    
    def apply_filters(self):
        self.display_records()
    
    def on_record_select(self, event):
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
            except Exception:
                pass  # Handle case where record isn't found
    
    def on_feature_change(self, event):
        self.analyze_feature_usage()
    
    def analyze_feature_usage(self):
        if self.df is None or self.df.empty:
            return
        
        selected_feature = self.analysis_feature_var.get()
        if not selected_feature or selected_feature == 'All':
            return
        
        # Filter for the selected feature
        feature_df = self.df[self.df['event_name'] == selected_feature]
        
        if feature_df.empty:
            self.stats_text.delete(1.0, tk.END)
            self.stats_text.insert(tk.END, f"No data found for feature: {selected_feature}")
            return
        
        # Calculate statistics
        stats = []
        stats.append(f"Feature: {selected_feature}")
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
        if self.df is None or self.df.empty:
            return
        
        selected_feature = self.analysis_feature_var.get()
        if not selected_feature or selected_feature == 'All':
            messagebox.showwarning("Warning", "Please select a specific feature to visualize")
            return
        
        # Clear previous visualization
        for widget in self.viz_frame.winfo_children():
            widget.destroy()
        
        # Create a new figure
        fig, axes = plt.subplots(2, 2, figsize=(12, 10))
        fig.suptitle(f'Feature Usage Analysis: {selected_feature}', fontsize=16)
        
        # Filter for the selected feature
        feature_df = self.df[self.df['event_name'] == selected_feature]
        
        if feature_df.empty:
            # Show message if no data
            label = ttk.Label(self.viz_frame, text=f"No data found for feature: {selected_feature}")
            label.pack(pady=20)
            return
        
        # Plot 1: Event types over time
        event_counts = feature_df.groupby([feature_df['timestamp'].dt.date, 'event_type']).size().unstack(fill_value=0)
        event_counts.plot(kind='bar', ax=axes[0,0], width=0.8)
        axes[0,0].set_title('Event Types Over Time')
        axes[0,0].set_xlabel('Date')
        axes[0,0].set_ylabel('Event Count')
        axes[0,0].tick_params(axis='x', rotation=45)
        
        # Plot 2: Platform distribution
        platform_counts = feature_df['platform'].value_counts()
        axes[0,1].pie(platform_counts.values, labels=platform_counts.index, autopct='%1.1f%%')
        axes[0,1].set_title('Platform Distribution')
        
        # Plot 3: Daily activity pattern
        daily_counts = feature_df.groupby(feature_df['timestamp'].dt.date).size()
        axes[1,0].plot(daily_counts.index, daily_counts.values, marker='o')
        axes[1,0].set_title('Daily Activity Trend')
        axes[1,0].set_xlabel('Date')
        axes[1,0].set_ylabel('Event Count')
        axes[1,0].tick_params(axis='x', rotation=45)
        
        # Plot 4: App version distribution
        if 'app_version' in feature_df.columns:
            version_counts = feature_df['app_version'].value_counts()
            if not version_counts.empty:
                axes[1,1].bar(version_counts.index, version_counts.values)
                axes[1,1].set_title('App Version Distribution')
                axes[1,1].set_xlabel('App Version')
                axes[1,1].set_ylabel('Event Count')
                axes[1,1].tick_params(axis='x', rotation=45)
            else:
                axes[1,1].text(0.5, 0.5, 'No version data', horizontalalignment='center', verticalalignment='center', transform=axes[1,1].transAxes)
                axes[1,1].set_title('App Version Distribution')
        else:
            axes[1,1].text(0.5, 0.5, 'No version data', horizontalalignment='center', verticalalignment='center', transform=axes[1,1].transAxes)
            axes[1,1].set_title('App Version Distribution')
        
        # Adjust layout to prevent overlap
        plt.tight_layout()
        
        # Embed the plot in the Tkinter window
        canvas = FigureCanvasTkAgg(fig, master=self.viz_frame)
        canvas.draw()
        canvas.get_tk_widget().pack(fill=tk.BOTH, expand=True)
        
        # Store reference to canvas to prevent garbage collection
        self.canvas = canvas


def main():
    root = tk.Tk()
    app = TrackingDataAnalyzer(root)
    root.mainloop()


if __name__ == "__main__":
    main()