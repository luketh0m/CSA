Feature: Forum post
   As a logged in user
   I want to be able to create a new thread post on the CSA
   So that other CSA users can reply to my post  
    
   Scenario: Create a thread post
     Given that user "admin" with password "taliesin" has logged in 
     When the user creates a new anonymous thread with the title "Assignment help" with the body "I need help"
     Then the current page should contain a new row containing the data:
     | Title           | Author    | Unread posts | Total number posts |
     | Assignment help | anonymous | 0            | 1                  |