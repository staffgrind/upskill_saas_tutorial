class ContactsController < ApplicationController
    
    # GET request to  /contact-us
    # Show new contact form
    def new
        @contact = Contact.new
    end
    
    # POST request to /contacts
    def create
        # Mass assignment of form fields into Contact object
        @contact = Contact.new(contact_params)
        # Save Contact ojbect to the database
        if @contact.save
            # Store form fields via parameters into variables
            name = params[:contact][:name]
            email = params[:contact][:email]
            body = params[:contact][:comments]
            # Plug variables into Contact mailer
            # Email method and send email
            ContactMailer.contact_email(name, email, body).deliver
            # Store success message in flash hash
            # Redirect to new action
            flash[:success] = "Message sent."
            redirect_to new_contact_path
        else
            # If Contact oject doesn't save:
            # Store errors in flash hash and
            # Redirect to new action
            flash[:danger] = @contact.errors.full_messages.join(", ")
            redirect_to new_contact_path
        end
    end
    
    private
        # To collect data from form, need to use
        # Strong parameters and whitelist form fields
        def contact_params
           params.require(:contact).permit(:name, :email, :comments) 
        end
end