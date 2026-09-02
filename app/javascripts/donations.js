function showDonationPopup() {
  var popup = document.querySelector('.donation-popup');
  if (popup) {
    popup.style.display = 'block';
    var supportBar = document.querySelector('#supportBar');
    if (supportBar) {
      supportBar.style.display = 'none';
    }
    document.body.style.overflow = 'hidden';
  }
}

function closeDonationPopup() {
  var popup = document.querySelector('.donation-popup');
  if (popup) {
    popup.style.display = 'none';
    var supportBar = document.querySelector('#supportBar');
    if (supportBar) {
      supportBar.style.display = 'flex';
    }
    document.body.style.overflow = 'auto';
    localStorage.setItem('donationPopupShown', 'true');
  }
}

function remindMeLaterDonation() {
  closeDonationPopup();
}

function setupRazorpayDonationButton() {
  var paymentButtonId = 'pl_FTB1pZqrFP6jrt';
  
  function renderRazorpayButton() {
    var container = document.querySelector('.razorpay-container');
    if (container) {
      container.innerHTML = '';
      var script = document.createElement('script');
      script.src = 'https://checkout.razorpay.com/v1/payment-button.js';
      script.setAttribute('data-payment_button_id', paymentButtonId);
      script.async = true;
      container.appendChild(script);
    }
  }

  if (document.readyState === 'complete') {
    renderRazorpayButton();
  } else {
    document.addEventListener('DOMContentLoaded', renderRazorpayButton);
  }
}

function setupDonationEventListeners() {
  var supportBar = document.querySelector('#supportBar');
  if (supportBar) {
    supportBar.addEventListener('click', function(e) {
      e.preventDefault();
      showDonationPopup();
    });
  }

  var closeBtn = document.querySelector('.donation-popup-close');
  if (closeBtn) {
    closeBtn.addEventListener('click', function(e) {
      e.preventDefault();
      closeDonationPopup();
    });
  }

  var remindBtn = document.querySelector('.donation-popup-btn-remind');
  if (remindBtn) {
    remindBtn.addEventListener('click', function(e) {
      e.preventDefault();
      remindMeLaterDonation();
    });
  }
}

function handleRazorpayPayment(event) {
  var token = document.querySelector('meta[name="csrf-token"]');
  if (!token) return;

  fetch('/donations', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': token.getAttribute('content')
    },
    body: JSON.stringify({
      donation: {
        donor_name: 'Anonymous',
        donor_email: '',
        amount: 100,
        currency: 'INR',
        notes: 'Donation via Razorpay'
      }
    })
  })
  .then(function(response) { return response.json(); })
  .then(function(data) {
    if (data.success) {
      localStorage.setItem('donationCompleted', 'true');
      closeDonationPopup();
      showThankYouMessage();
    }
  })
  .catch(function(error) {
    console.error('Error creating donation:', error);
  });
}

function showThankYouMessage() {
  var message = document.createElement('div');
  message.className = 'thank-you-message';
  message.innerHTML = '<div style="position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); background: #4CAF50; color: white; padding: 20px 40px; border-radius: 8px; font-size: 18px; z-index: 10000; box-shadow: 0 4px 12px rgba(0,0,0,0.15);">ಧನ್ಯವಾದಗಳು!</div>';
  document.body.appendChild(message);
  
  setTimeout(function() {
    if (message.parentNode) {
      message.parentNode.removeChild(message);
    }
  }, 5000);
}

document.addEventListener('DOMContentLoaded', function() {
  setupDonationEventListeners();
  setupRazorpayDonationButton();
});

window.showDonationPopup = showDonationPopup;
window.closeDonationPopup = closeDonationPopup;
window.remindMeLaterDonation = remindMeLaterDonation;
