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

    private var isSignInDisabled: Bool {
        username.isEmpty || password.isEmpty
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Logo/Title
            VStack(spacing: 8) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(Brand.primaryGradient)
                
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
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .brandField()
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Password")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    SecureField("Enter your password", text: $password)
                        .brandField()
                }
            }
            
            // Login Button
            Button(action: {
                // Login action would go here
            }) {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(isSignInDisabled ? Color.secondary : .white)
                    .frame(maxWidth: .infinity)
                    .frame(height: Brand.controlHeight)
                    .background {
                        if isSignInDisabled {
                            Brand.disabledFill
                        } else {
                            Brand.primaryGradient
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: Brand.buttonRadius))
            }
            .disabled(isSignInDisabled)
            
            // Forgot Password Link
            Button(action: {
                // Forgot password action would go here
            }) {
                Text("Forgot Password?")
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(.accentColor)
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