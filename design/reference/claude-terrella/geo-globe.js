(function () {
  if (customElements.get('contrail-globe')) return;
  const ready = () => new Promise(r => { (function c() { (window.d3 && window.topojson) ? r() : setTimeout(c, 60); })(); });
  const world = () => (window.__ctWorld || (window.__ctWorld = fetch('https://cdn.jsdelivr.net/npm/world-atlas@2.0.2/countries-110m.json').then(r => r.json())));
  const APT = { SFO: [-122.379, 37.621], JFK: [-73.778, 40.641], SEA: [-122.309, 47.449] };
  const PP = { SFO: [-122.379, 37.621], JFK: [-73.778, 40.641], SEA: [-122.309, 47.449], HNL: [-157.92, 21.32], MEX: [-99.07, 19.44], ORD: [-87.9, 41.98], MIA: [-80.29, 25.79], YVR: [-123.18, 49.19], AUS: [-97.67, 30.19] };
  const PAST = [['SFO', 'JFK'], ['SFO', 'HNL'], ['SFO', 'MEX'], ['SEA', 'JFK'], ['SFO', 'ORD'], ['JFK', 'MIA'], ['SFO', 'YVR'], ['AUS', 'JFK']];

  class ContrailGlobe extends HTMLElement {
    async connectedCallback() {
      this.style.display = 'block';
      const aw = +this.getAttribute('data-w') || 0, ah = +this.getAttribute('data-h') || 0;
      if (aw) this.style.width = aw + 'px';
      if (ah) this.style.height = ah + 'px';
      const W = aw || this.clientWidth || 358, H = ah || this.clientHeight || 330;
      const dpr = Math.min(window.devicePixelRatio || 1, 2);
      const cv = document.createElement('canvas');
      cv.width = W * dpr; cv.height = H * dpr;
      cv.style.cssText = 'width:100%;height:100%;display:block';
      this.appendChild(cv);
      await ready();
      const topo = await world();
      if (!this.isConnected) return;
      const land = topojson.feature(topo, topo.objects.land);
      const ctx = cv.getContext('2d'); ctx.scale(dpr, dpr);
      const R = W * 0.62, cx = W / 2, cy = H * 0.78;
      const proj = d3.geoOrthographic().translate([cx, cy]).scale(R).clipAngle(90).rotate([99, -32, -14]);
      const path = d3.geoPath(proj, ctx);

      // static layers rendered once to an offscreen buffer
      const st = document.createElement('canvas');
      st.width = W * dpr; st.height = H * dpr;
      const sc = st.getContext('2d'); sc.scale(dpr, dpr);
      const spath = d3.geoPath(proj, sc);
      let g = sc.createRadialGradient(cx, cy, R * .93, cx, cy, R * 1.16);
      g.addColorStop(0, 'rgba(95,145,255,.30)'); g.addColorStop(1, 'rgba(95,145,255,0)');
      sc.fillStyle = g; sc.beginPath(); sc.arc(cx, cy, R * 1.16, 0, 7); sc.fill();
      g = sc.createRadialGradient(cx - R * .38, cy - R * .5, R * .1, cx, cy, R);
      g.addColorStop(0, '#182548'); g.addColorStop(.55, '#0d152e'); g.addColorStop(1, '#060a19');
      sc.beginPath(); sc.arc(cx, cy, R, 0, 7); sc.fillStyle = g; sc.fill();
      sc.beginPath(); spath(d3.geoGraticule10()); sc.strokeStyle = 'rgba(115,145,215,.10)'; sc.lineWidth = .6; sc.stroke();
      sc.beginPath(); spath(land); sc.fillStyle = 'rgba(75,105,190,.17)'; sc.fill();
      sc.save(); sc.shadowColor = 'rgba(95,155,255,.55)'; sc.shadowBlur = 5;
      sc.beginPath(); spath(land); sc.strokeStyle = 'rgba(140,180,255,.5)'; sc.lineWidth = .8; sc.stroke(); sc.restore();

      const stars = d3.range(80).map(() => [Math.random() * W, Math.random() * H * 0.55, Math.random()]);
      const visible = pt => d3.geoDistance([-99, 32], pt) < 1.52;
      const route = (a, b, o) => {
        const ip = d3.geoInterpolate(a, b);
        const seg = (t0, t1) => ({ type: 'LineString', coordinates: d3.range(t0, t1 + 0.001, 0.02).map(ip) });
        ctx.save();
        ctx.shadowColor = o.color; ctx.shadowBlur = 9;
        ctx.strokeStyle = o.color; ctx.lineWidth = o.width || 1.6; ctx.lineCap = 'round';
        if (o.prog != null) {
          ctx.beginPath(); path(seg(0, o.prog)); ctx.stroke();
          ctx.globalAlpha = .45; ctx.setLineDash([2, 5]);
          ctx.beginPath(); path(seg(o.prog, 1)); ctx.stroke();
          ctx.setLineDash([]); ctx.globalAlpha = 1;
          const p = proj(ip(o.prog)), q = proj(ip(Math.min(o.prog + .02, 1)));
          if (p && q && visible(ip(o.prog))) {
            const ang = Math.atan2(q[1] - p[1], q[0] - p[0]);
            ctx.translate(p[0], p[1]); ctx.rotate(ang);
            ctx.shadowBlur = 14; ctx.fillStyle = '#fff';
            ctx.beginPath(); ctx.moveTo(7, 0); ctx.lineTo(-5, -4.5); ctx.lineTo(-2.5, 0); ctx.lineTo(-5, 4.5); ctx.closePath(); ctx.fill();
          }
        } else {
          if (o.dash) ctx.setLineDash(o.dash);
          ctx.beginPath(); path(seg(0, 1)); ctx.stroke(); ctx.setLineDash([]);
        }
        ctx.restore();
      };
      const airport = (code, dx, dy, hot) => {
        if (!visible(APT[code])) return;
        const p = proj(APT[code]); if (!p) return;
        ctx.save();
        ctx.fillStyle = hot ? '#ffb454' : '#dfe8ff';
        ctx.shadowColor = hot ? '#ffb454' : '#7fa8ff'; ctx.shadowBlur = 8;
        ctx.beginPath(); ctx.arc(p[0], p[1], 2.6, 0, 7); ctx.fill();
        ctx.shadowBlur = 0;
        ctx.font = '700 10px "Space Mono", monospace';
        ctx.fillStyle = hot ? '#ffcd8a' : '#aebfe8';
        ctx.fillText(code, p[0] + dx, p[1] + dy);
        ctx.restore();
      };

      const mode = this.getAttribute('data-mode') || '';
      const mainProg = this.getAttribute('data-main-prog');
      const t0 = performance.now();
      let last = 0;
      const draw = now => {
        this._raf = requestAnimationFrame(draw);
        if (now - last < 33) return;
        last = now;
        const t = (now - t0) / 1000;
        ctx.clearRect(0, 0, W, H);
        for (const [x, y, a] of stars) {
          ctx.globalAlpha = .2 + .55 * a * (.6 + .4 * Math.sin(t * 1.8 + a * 30));
          ctx.fillStyle = '#a9bcec'; ctx.fillRect(x, y, 1.4, 1.4);
        }
        ctx.globalAlpha = 1;
        ctx.drawImage(st, 0, 0, W, H);
        if (mode === 'passport') {
          PAST.forEach(([a, b], i) => route(PP[a], PP[b], { color: i % 2 ? '#6fd8ff' : '#a98bff', width: 1.1 }));
          ctx.save(); ctx.fillStyle = '#dfe8ff'; ctx.shadowColor = '#7fa8ff'; ctx.shadowBlur = 6;
          Object.values(PP).forEach(c => { if (visible(c)) { const p = proj(c); ctx.beginPath(); ctx.arc(p[0], p[1], 2, 0, 7); ctx.fill(); } });
          ctx.restore();
          airport('SFO', -34, 12, true);
        } else if (mainProg != null) {
          route(APT.SFO, APT.JFK, { color: '#6fd8ff', width: 2, prog: +mainProg });
          airport('SFO', -34, 12, false);
          airport('JFK', 8, 4, true);
        } else {
          route(APT.SFO, APT.JFK, { color: '#6fd8ff', width: 1.5, dash: [3, 6] });
          route(APT.SEA, APT.SFO, { color: '#ffb454', width: 2, prog: .62 + (t * .004) % .3 });
          airport('SEA', -8, -7, false);
          airport('SFO', -34, 12, true);
          airport('JFK', 8, 4, false);
        }
      };
      this._raf = requestAnimationFrame(draw);
    }
    disconnectedCallback() { cancelAnimationFrame(this._raf); }
  }
  customElements.define('contrail-globe', ContrailGlobe);
})();
