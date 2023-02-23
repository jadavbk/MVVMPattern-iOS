# MVVMPattern-iOS

<h1>Introduction</h1>
Here I am presenting an interesting Component that is very essesntial for  develpement with MVVM pattern. 
MVVM pattern is a component, which lets you find the easy way to API call using Model - View - ViewModel Pattern with latest code using Alamofire. In this component I have focused on basic MVVM design pattern with creating model class, view model class and common API class from you can call API usign view model.  

<br/><br/>
<h1>Features</h1>

- Manage central API call from view-model class.
- Create Model Class that get the API call reponse parameters usign Struct.
- Manage different types of response data with Error management.
- Easy manage upload image with multipart form data request.

<br/><br/>
<h1>Getting Started</h1>

To use this component in your project you need to perform the below steps:

> Steps to Integrate


1) Drag and drop `BaseHelper` and `BaseWebClient` folders to your project.

2) Add `Alamofire` pod to your project.

3) Review the code from the class `FaqResponseModel` for model creation, `FaqViewModel` for view-model creation where API call has been implemented.

4) Check the calss `ViewController` where the View-Model class object created and implement the call function of view-model to get the data from API and store that data in to view-Model Class.


**Note:** Make sure that the extension which is used in this component has been added to your project. 


<br/><br/>
**<h1>Bugs and Feedback</h1>**
For bugs, questions and discussions please use the Github Issues.


<br/><br/>
**<h1>License</h1>**
The MIT License (MIT)
<br/><br/>
Copyright (c) 2020 Bharat
<br/><br/>
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: 
<br/><br/>
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

<br/>
<h1></h1>



