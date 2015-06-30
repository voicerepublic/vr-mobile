//script for inAppBrowser
(function(){

	//inject a back "button" so that the user can return to the app
	var back = document.querySelector(".name");
	back.innerHTML = "&nbsp < Back";
	back.style.color = "white";
	back.addEventListener("click", function(e){
		window.location += "#backToTheApp";
		window.location.reload();
	});

	//remove the modal
	var modal = document.querySelector("#nagModal");
	if (modal)
		modal.remove();

	//hide the menu so that user cannot navigate away
	var menu = document.querySelector(".menu-icon");
	menu.style.display = "none";

	//handle click on VR logo not to navigate away
	var logoLink = document.querySelector(".icon-vr-logo").parentNode;
	logoLink.href = "#";

	//hide the linksbox
	var linksbox = document.querySelector(".links-box");
	if (linksbox)
		linksbox.style.display = "none";

	//hide the facebook button until we integrate native 
	//login with facebook
	var facebookButton = document.querySelector(".facebook");
	if (facebookButton)
		facebookButton.style.display = "none";

	//remove the hr tags
	var hrElements = document.getElementsByTagName("hr");
	angular.forEach(hrElements, function(hrElement){
		hrElement.style.display = "none";
	});

	//hide links in password renew page
	var pwlinksContainer = document.querySelector('.medium-offset-1');
	if (pwlinksContainer) {
		pwlinks = pwlinksContainer.children;
		angular.forEach(pwlinks, function(link){
			if (link.tagName === "A") {
				link.style.display = "none";
			}
		});
	}

	//hide footer links except copyrights
	var footerLinks = document.querySelector(".list-style-type-none").children;
	angular.forEach(footerLinks, function(child){
		if (child.childElementCount != 1) {
			child.style.display = "none";
		}
	});

})(window);
