Hidden Markov Models [<img src="https://github.com/StarlangSoftware/Hmm/blob/master/video1.jpg" width="5%">](https://youtu.be/zHj5mK3jcyk)[<img src="https://github.com/StarlangSoftware/Hmm/blob/master/video2.jpg" width="5%">](https://youtu.be/LM0ld3UKCEs)
============

For Developers
============
You can also see [Java](https://github.com/starlangsoftware/Hmm), [Python](https://github.com/starlangsoftware/Hmm-Py), [Cython](https://github.com/starlangsoftware/Hmm-Cy), [C#](https://github.com/starlangsoftware/Hmm-CS), [Js](https://github.com/starlangsoftware/Hmm-Js), or [C++](https://github.com/starlangsoftware/Hmm-CPP) repository.

## Requirements

* Xcode Editor
* [Git](#git)

### Git

Install the [latest version of Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

## Download Code

In order to work on code, create a fork from GitHub page. 
Use Git for cloning the code to your local or below line for Ubuntu:

	git clone <your-fork-git-link>

A directory called Hmm-Swift will be created. Or you can use below link for exploring the code:

	git clone https://github.com/starlangsoftware/Hmm-Swift.git

## Open project with XCode

To import projects from Git with version control:

* XCode IDE, select Clone an Existing Project.

* In the Import window, paste github URL.

* Click Clone.

Result: The imported project is listed in the Project Explorer view and files are loaded.


## Compile

**From IDE**

After being done with the downloading and opening project, select **Build** option from **Product** menu. After compilation process, user can run Hmm-Swift.

Detailed Description
============

+ [Hmm](#hmm)

## Hmm

Hmm modelini üretmek için

	init(states: Set<State>, observations: [[State]], emittedSymbols: [[Symbol]])


Viterbi algoritması ile en olası State listesini elde etmek için

	func viterbi(s: [Symbol]) -> [State]
