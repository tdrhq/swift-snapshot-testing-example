//
//  LoginView.swift
//  SimpleProject
//
//  Created by Arnold Noronha on 1/5/24.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack(spacing: 24) {
            // Logo/Title
            VStack(spacing: 8) {
                Image(systemName: "person.circle")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                
                Text("Welcome Back")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Sign in to your account")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 20)
            
            // Input Fields
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Username")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    TextField("Enter your username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Password")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    SecureField("Enter your password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            
            // Login Button
            Button(action: {
                // Login action would go here
            }) {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(username.isEmpty || password.isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(10)
            }
            .disabled(username.isEmpty || password.isEmpty)
            
            // Forgot Password Link
            Button(action: {
                // Forgot password action would go here
            }) {
                Text("Forgot Password?")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }
            .padding(.top, 8)
            
            Spacer()
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 40)
    }
}

#Preview {
    LoginView()
}