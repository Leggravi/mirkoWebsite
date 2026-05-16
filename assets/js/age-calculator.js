// Dynamisches Alter berechnen (01.02.2007)
(function(){
  const birth = '2007-02-01'; // YYYY-MM-DD
  const b = new Date(birth);
  const now = new Date();
  let age = now.getFullYear() - b.getFullYear();
  const m = now.getMonth() - b.getMonth();
  if (m < 0 || (m === 0 && now.getDate() < b.getDate())) age--;
  
  // Aktualisiere alle Elemente mit age/age-about Klasse oder ID
  const ageEl = document.getElementById('age');
  if (ageEl) ageEl.textContent = age;
  
  const ageAboutEl = document.getElementById('age-about');
  if (ageAboutEl) ageAboutEl.textContent = age;
})();
