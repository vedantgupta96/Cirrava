(function () {
  if (customElements.get('contrail-map')) return;
  const ready = () => new Promise(r => { (function c() { (window.d3 && window.topojson) ? r() : setTimeout(c, 60); })(); });
  const world = () => (window.__ctWorld || (window.__ctWorld = fetch('https://cdn.jsdelivr.net/npm/world-atlas@2.0.2/countries-110m.json').then(r => r.json())));
  const APT = { SFO: [-122.379, 37.621], JFK: [-73.778, 40.641], SEA: [-122.309, 47.449] };

  class ContrailMap extends HTMLElement {
    async connectedCallback() {
      this.style.display = 'block';
      const aw = +this.getAttribute('data-w') || 0, ah = +this.getAttribute('data-h') || 0;
      if (aw) this.style.width = aw + 'px';
      if (ah) this.style.height = ah + 'px';
      const W = aw || this.clientWidth || 358, H = ah || this.clientHeight || 788;
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
      const fb = parseFloat(this.getAttribute('data-fit-bottom') || '.56');
      const pt = parseFloat(this.getAttribute('data-pad-top') || '120');
      const proj = d3.geoMercator().fitExtent([[16, pt], [W - 16, H * fb]],
        { type: 'MultiPoint', coordinates: [[-127, 22.5], [-65, 51]] });
      const path = d3.geoPath(proj, ctx);

      // static layers once
      const st = document.createElement('canvas');
      st.width = W * dpr; st.height = H * dpr;
      const sc = st.getContext('2d'); sc.scale(dpr, dpr);
      const spath = d3.geoPath(proj, sc);
      sc.beginPath(); spath(d3.geoGraticule10()); sc.strokeStyle = 'rgba(110,140,210,.08)'; sc.lineWidth = .6; sc.stroke();
      sc.beginPath(); spath(land); sc.fillStyle = 'rgba(72,100,185,.13)'; sc.fill();
      sc.save(); sc.shadowColor = 'rgba(95,155,255,.5)'; sc.shadowBlur = 5;
      sc.beginPath(); spath(land); sc.strokeStyle = 'rgba(140,180,255,.42)'; sc.lineWidth = .9; sc.stroke(); sc.restore();

      const route = (a, b, o, t) => {
        const ip = d3.geoInterpolate(a, b);
        const seg = (t0, t1) => ({ type: 'LineString', coordinates: d3.range(t0, t1 + .001, .02).map(ip) });
        ctx.save();
        ctx.shadowColor = o.color; ctx.shadowBlur = 10;
        ctx.strokeStyle = o.color; ctx.lineWidth = o.width || 1.6; ctx.lineCap = 'round';
        if (o.prog != null) {
          ctx.beginPath(); path(seg(0, o.prog)); ctx.stroke();
          ctx.globalAlpha = .4; ctx.setLineDash([2, 5]);
          ctx.beginPath(); path(seg(o.prog, 1)); ctx.stroke();
          ctx.setLineDash([]); ctx.globalAlpha = 1;
          const p = proj(ip(o.prog)), q = proj(ip(Math.min(o.prog + .02, 1)));
          const ang = Math.atan2(q[1] - p[1], q[0] - p[0]);
          ctx.translate(p[0], p[1]);
          ctx.shadowBlur = 0; ctx.fillStyle = 'rgba(255,180,84,.18)';
          ctx.beginPath(); ctx.arc(0, 0, 11 + 4 * Math.sin(t * 2.4), 0, 7); ctx.fill();
          ctx.rotate(ang); ctx.shadowBlur = 14; ctx.fillStyle = '#fff';
          ctx.beginPath(); ctx.moveTo(8, 0); ctx.lineTo(-6, -5); ctx.lineTo(-3, 0); ctx.lineTo(-6, 5); ctx.closePath(); ctx.fill();
        } else {
          if (o.dash) { ctx.setLineDash(o.dash); ctx.lineDashOffset = -t * 8; }
          ctx.beginPath(); path(seg(0, 1)); ctx.stroke(); ctx.setLineDash([]);
        }
        ctx.restore();
      };
      const airport = (code, dx, dy, hot, t) => {
        const p = proj(APT[code]);
        ctx.save();
        if (hot) {
          ctx.fillStyle = 'rgba(255,180,84,.16)';
          ctx.beginPath(); ctx.arc(p[0], p[1], 10 + 3 * Math.sin(t * 2), 0, 7); ctx.fill();
        }
        ctx.fillStyle = hot ? '#ffb454' : '#e6edff';
        ctx.shadowColor = hot ? '#ffb454' : '#7fa8ff'; ctx.shadowBlur = 9;
        ctx.beginPath(); ctx.arc(p[0], p[1], 3, 0, 7); ctx.fill();
        ctx.shadowBlur = 0;
        ctx.font = '700 11px "Space Mono", monospace';
        ctx.fillStyle = hot ? '#ffcd8a' : '#b6c5ea';
        ctx.fillText(code, p[0] + dx, p[1] + dy);
        ctx.restore();
      };

      const t0 = performance.now();
      let last = 0;
      const draw = now => {
        this._raf = requestAnimationFrame(draw);
        if (now - last < 33) return;
        last = now;
        const t = (now - t0) / 1000;
        ctx.clearRect(0, 0, W, H);
        ctx.drawImage(st, 0, 0, W, H);
        route(APT.SFO, APT.JFK, { color: '#6fd8ff', width: 1.6, dash: [3, 7] }, t);
        route(APT.SEA, APT.SFO, { color: '#ffb454', width: 2.2, prog: .78 }, t);
        airport('SEA', 9, -5, false, t);
        airport('SFO', -40, 3, true, t);
        airport('JFK', 9, 1, false, t);
      };
      this._raf = requestAnimationFrame(draw);
    }
    disconnectedCallback() { cancelAnimationFrame(this._raf); }
  }
  customElements.define('contrail-map', ContrailMap);
})();
