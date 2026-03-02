// API Service for Leave Management System

import axios from 'axios';

const API_BASE_URL = process.env.REACT_APP_API_BASE_URL || 'http://localhost:8080/api';

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor to add JWT token to every request
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Response interceptor to handle errors
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response && error.response.status === 401) {
      // Automatically logout if 401 response (unauthorized)
      localStorage.removeItem('token');
      localStorage.removeItem('user');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

// Authentication
export const login = async (username, password) => {
  const response = await api.post('/auth/login', { username, password });
  return response.data;
};

export const register = async (userData) => {
  const response = await api.post('/auth/register', userData);
  return response.data;
};

// Leave Requests
export const createLeaveRequest = async (requestData) => {
  const response = await api.post('/leave-requests', requestData);
  return response.data;
};

export const getMyLeaveRequests = async () => {
  const response = await api.get('/leave-requests/my-requests');
  return response.data;
};

export const getTeamRequests = async () => {
  const response = await api.get('/leave-requests/team-requests');
  return response.data;
};

export const getLeaveRequest = async (id) => {
  const response = await api.get(`/leave-requests/${id}`);
  return response.data;
};

export const approveLeaveRequest = async (id, comments) => {
  const response = await api.put(`/leave-requests/${id}/approve`, { comments });
  return response.data;
};

export const rejectLeaveRequest = async (id, comments) => {
  const response = await api.put(`/leave-requests/${id}/reject`, { comments });
  return response.data;
};

// Leave Balances
export const getMyLeaveBalances = async () => {
  const response = await api.get('/leave-balances/my-balances');
  return response.data;
};

// Leave Types
export const getLeaveTypes = async () => {
  const response = await api.get('/leave-types');
  return response.data;
};

// Reports
export const generateTeamReport = async (startDate, endDate) => {
  const response = await api.get('/reports/team', {
    params: { startDate, endDate }
  });
  return response.data;
};

export default api;